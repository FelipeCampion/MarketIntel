# 🏗️ MarketIntel: Arquitetura de Dados Multibancos

O **MarketIntel** é um ecossistema de dados corporativo desenvolvido em **SQL Server (T-SQL)**. O projeto simula um ambiente real de alta escalabilidade, utilizando uma arquitetura distribuída para gerir fluxos complexos de suprimentos, vendas e finanças.

---

## 🚀 Novas Funcionalidades

* **Inteligência de Suprimentos (Sugestão de Compra):** Procedure que utiliza `Window Functions` e `CTEs` para analisar estoques baixos e sugerir automaticamente o fornecedor com o menor custo de aquisição.
* **Auditoria de Preços:** Implementação de triggers de segurança que monitoram alterações em valores sensíveis, registrando o histórico de mudanças, o usuário responsável e o carimbo de data/hora (log).
* **Mecanismo de Pagamento a Prazo:** Automação de fluxo de caixa que gera parcelas e datas de vencimento na tabela de `contas_a_receber` via laços de repetição (`WHILE`) em Stored Procedures.
* **Gestão de Suprimentos N:N:** Evolução para um relacionamento "Muitos para Muitos", permitindo que um produto tenha múltiplos fornecedores com custos e prazos distintos.
* **Cálculo de Lucro Automatizado:** Triggers que calculam o lucro líquido de cada venda em tempo real, confrontando o preço de venda com o custo de aquisição.

---

## Diferenciais Técnicos
* **Arquitetura Distribuída:** Segregação em 5 bancos de dados (CRM, Produtos, Vendas, Pedidos e Financeiro).
* **Interoperabilidade via Synonyms:** Comunicação transparente entre bases de dados distintas através de sinônimos.
* **Atomicidade em Transações:** Uso de `BEGIN TRANSACTION` e `ROLLBACK` para garantir a integridade dos dados em operações financeiras complexas.
* **Normalização Avançada:** Estrutura mestre-detalhe e tabelas associativas para eliminar redundância e garantir a Terceira Forma Normal (3FN).

---

## Estrutura do Ecossistema

O projeto segue uma ordem lógica de execução para garantir a integridade das referências:

1.  **`01_DB_CRM`**: Gestão de clientes e dados de contato.
2.  **`02_DB_Produtos`**: Catálogo, gestão multi-fornecedor, estoque e logs de auditoria.
3.  **`03_DB_Vendas`**: PDV com automação de parcelamento e vendas diretas.
4.  **`04_DB_Pedidos`**: Fluxo omnichannel (e-commerce e presencial).
5.  **`05_DB_Financeiro`**: Inteligência de BI, fechamentos mensais e gestão de metas.
6.  **`06_Procedures_Triggers`**: Camada de automação e regras de negócio.
7.  **`07_DML_Povoamento`**: Script de carga inicial para testes de integração.

---

## Como Executar
1. Certifique-se de ter o **SQL Server** instalado.
2. Execute os scripts na ordem numérica (01 a 07).
3. Após o script 07, utilize a procedure para testar a inteligência de compras:

```sql
/* Gera sugestão de compra baseada no menor preço de fornecedor */
exec db_marketintel_produtos.dbo.sp_sugestao_compra_barata;

/* Registra uma venda parcelada em 3x */
exec db_marketintel_vendas.dbo.sp_registrar_venda 
    @id_cliente = 1, 
    @id_produto = 1, 
    @qtd = 2, 
    @forma_pgto = 1, 
    @num_parcelas = 3;
