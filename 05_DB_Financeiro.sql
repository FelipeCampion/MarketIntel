create database DB_MarketIntel_Financeiro;
go

use DB_MarketIntel_Financeiro;
go

create table compra_produto(
id_compra int identity(1,1) primary key,
id_produto bigint,
id_tipo int,
id_fornecedor bigint,
custo_compra_unid decimal(10,2),
custo_compra_total decimal(10,2)
);

create table contas_a_pagar(
id_conta bigint identity(1,1) primary key,
id_compra int,
id_fornecedor bigint,
valor_conta decimal(10,2) not null,
data_vencimento date not null,
data_pagamento datetime2,
status_pagamento varchar(20) default 'Pendente',
n_nf_origem int
);

create table metas_vendas(
id_meta int identity(1,1) primary key,
id_tipo_produto int,
mes_referencia int not null,
ano_referencia int not null,
valor_meta_faturamento decimal(12,2) not null,
qtd_meta_itens int
);

create table projecao_vendas(
id_projecao int identity(1,1) primary key,
id_produto bigint,
data_projecao date not null,
qtd_estimada int,
valor_estimado_venda decimal(10,2)
);

create table fechamento_mensal_vendas(
id_fechamento int identity(1,1) primary key,
mes_referencia int not null,
ano_referencia int not null,
faturamento_total_real decimal(15,2),
lucro_total_real decimal(15,2),
qtd_total_vendas int,
ticket_medio decimal(10,2)
);

go

alter table contas_a_pagar
add constraint fk_contas_compra foreign key (id_compra) references compra_produto (id_compra);

go

use db_marketintel_financeiro;
go

create synonym dim_produtos for db_marketintel_produtos.dbo.produtos;
create synonym dim_fornecedores for db_marketintel_produtos.dbo.fornecedores;
create synonym dim_tipo_produto for db_marketintel_produtos.dbo.tipo;
create synonym fato_vendas for db_marketintel_vendas.dbo.vendas;
create synonym fato_pedidos_ecom for db_marketintel_pedidos.dbo.pedidos_ecom;
go

use db_marketintel_financeiro;
go

create procedure sp_gerar_fechamento_mensal
    @mes int,
    @ano int
as
begin
    declare @faturamento_vendas decimal(15,2);
    declare @faturamento_pedidos decimal(15,2);

    select @faturamento_vendas = sum(valor_venda) from fato_vendas 
    where month(data_venda) = @mes and year(data_venda) = @ano;

    select @faturamento_pedidos = sum(valor_venda) from fato_pedidos_ecom 
    where month(data_pedido) = @mes and year(data_pedido) = @ano;

    insert into fechamento_mensal_vendas (mes_referencia, ano_referencia, faturamento_total_real)
    values (@mes, @ano, isnull(@faturamento_vendas,0) + isnull(@faturamento_pedidos,0));
    
    print 'fechamento financeiro gerado com sucesso!';
end;
go
