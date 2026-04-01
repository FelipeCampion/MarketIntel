# 🏗️ MarketIntel: Arquitetura de Dados Multibancos

O **MarketIntel** é um ecossistema de dados corporativo desenvolvido em **SQL Server (T-SQL)**. O projeto simula um ambiente real de alta escalabilidade, onde diferentes domínios de negócio são segregados em bancos de dados independentes, mas integrados de forma inteligente.

---

## Diferenciais Técnicos
* **Arquitetura Distribuída:** Separação de responsabilidades em 5 bancos de dados (CRM, Produtos, Vendas, Pedidos e Financeiro).
* **Interoperabilidade via Synonyms:** Uso de Sinônimos para comunicação transparente entre bases de dados distintas.
* **Automação de Negócio:** Implementação de `Stored Procedures` para vendas e `Triggers` para controle automático de estoque e cálculo de lucro.
* **Integridade Lógica:** Modelagem de tabelas de histórico preparadas para consolidar dados de múltiplas origens (Omnichannel).

---

## Estrutura do Ecossistema

O projeto segue uma ordem lógica de execução para garantir a integridade das referências:

1.  **`01_DB_CRM`**: Gestão de Clientes e dados sensíveis de contato.
2.  **`02_DB_Produtos`**: Catálogo de produtos, gestão de fornecedores e controle de estoque.
3.  **`03_DB_Vendas`**: Processamento de vendas diretas e PDV.
4.  **`04_DB_Pedidos`**: Fluxo de pedidos de E-commerce e Presenciais (Omnichannel).
5.  **`05_DB_Financeiro`**: Inteligência de BI, fechamentos mensais, metas e projeções.
6.  **`06_Procedures_Triggers`**: Camada de automação e regras de negócio.
7.  **`07_DML_Povoamento`**: Script de carga inicial para testes de integração.

---

## Como Executar
1. Certifique-se de ter o **SQL Server** instalado.
2. Execute os scripts na ordem numérica (01 a 07).
3. Após o script 07, utilize as Procedures para testar a integração:
   ```sql
   exec db_marketintel_vendas.dbo.sp_registrar_venda 
        @id_cliente = 1, 
        @id_produto = 1, 
        @qtd = 2, 
        @forma_pgto = 1;
