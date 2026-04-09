# 🏗️ MarketIntel: Arquitetura de Dados Multibancos

o **marketintel** é um ecossistema de dados corporativo desenvolvido em **sql server (t-sql)**. o projeto simula um ambiente real de alta escalabilidade, utilizando uma arquitetura distribuída para gerir fluxos complexos de suprimentos e finanças.

---

## 🚀 Novas funcionalidades

* **mecanismo de pagamento a prazo:** automação de fluxo de caixa que gera automaticamente parcelas e datas de vencimento na tabela de `contas_a_receber` via laços de repetição (`while`) em stored procedures.
* **gestão de suprimentos n:n:** evolução do modelo de fornecedores para um relacionamento "muitos para muitos". agora, um produto pode ter múltiplos fornecedores com custos e prazos distintos, permitindo inteligência na escolha do melhor parceiro de compra.
* **cálculo de lucro automatizado:** implementação de triggers que calculam o lucro líquido de cada venda em tempo real, confrontando o preço de venda com o custo médio de aquisição do produto.

---

## Diferenciais técnicos
* **arquitetura distribuída:** segregação em 5 bancos de dados (crm, produtos, vendas, pedidos e financeiro).
* **interoperabilidade via synonyms:** comunicação transparente entre bases de dados distintas através de sinônimos.
* **atomicidade em transações:** uso de `begin transaction` e `rollback` para garantir a integridade dos dados em operações financeiras complexas.
* **normalização avançada:** estrutura mestre-detalhe e tabelas associativas para eliminar redundância e garantir a consistência (3fn).

---

## Estrutura do ecossistema

O projeto segue uma ordem lógica de execução para garantir a integridade das referências:

1.  **`01_db_crm`**: Gestão de clientes e dados de contato.
2.  **`02_db_produtos`**: Catálogo, gestão multi-fornecedor e controle de estoque.
3.  **`03_db_vendas`**: Pdv com automação de parcelamento e vendas diretas.
4.  **`04_db_pedidos`**: Fluxo omnichannel (e-commerce e presencial).
5.  **`05_db_financeiro`**: Inteligência de bi, fechamentos mensais e metas.
6.  **`06_procedures_triggers`**: Camada de automação e regras de negócio em lowercase.
7.  **`07_dml_povoamento`**: Script de carga inicial para testes de integração.

---

## Como executar
1. Ccertifique-se de ter o **sql server** instalado.
2. Execute os scripts na ordem numérica (01 a 07).
3. Após o script 07, utilize a procedure para testar o parcelamento automático:

```sql
/* registra uma venda parcelada em 3x */
exec db_marketintel_vendas.dbo.sp_registrar_venda 
    @id_cliente = 1, 
    @id_produto = 1, 
    @qtd = 2, 
    @forma_pgto = 1, 
    @num_parcelas = 3;

/* consulte as parcelas geradas */
select * from db_marketintel_vendas.dbo.contas_a_receber;
