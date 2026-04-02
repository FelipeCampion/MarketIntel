create database DB_MarketIntel_Vendas;
go

use DB_MarketIntel_Vendas;
go 

create table forma_pagamento(
    id_forma_pagamento int identity(1,1) primary key,
    nome_forma_pagamento varchar(25)
);

create table vendas(
    id_venda bigint identity(1,1) primary key,
    id_cliente bigint, 
    valor_venda_total decimal(10,2) default 0,
    data_venda datetime2 default sysutcdatetime,
    id_forma_pagamento int,
    status_venda varchar(20)
);

create table itens_venda(
    id_item_venda bigint identity(1,1) primary key,
    id_venda bigint not null,
    id_produto bigint not null, 
    quantidade_itens int not null,
    valor_unitario decimal(10,2) not null,
    valor_subtotal as (quantidade_itens * valor_unitario) 
);

create table vendas_lucros(
    id_venda_lucro bigint identity(1,1) primary key,
    id_venda bigint,
    valor_lucro_venda decimal(10,2)
);

create table historico_vendas(
    id_historico bigint identity(1,1) primary key,
    id_venda bigint,
    id_cliente bigint,
    valor_venda_total decimal(10,2),
    data_venda datetime2 not null
);

create table trocas(
    id_troca bigint identity(1,1) primary key,
    id_venda bigint, 
    id_produto_antigo bigint,
    quantidade_antiga int,
    id_produto_novo bigint,
    quantidade_nova int,
    motivo_troca varchar(max),
    lote_produto varchar(20),
    data_troca datetime2 default sysutcdatetime
);
go

alter table vendas
add constraint fk_vendas_pagamento foreign key (id_forma_pagamento) references forma_pagamento (id_forma_pagamento);

alter table itens_venda
add constraint fk_itens_venda_pai foreign key (id_venda) references vendas (id_venda);

alter table vendas_lucros
add constraint fk_lucros_vendas foreign key (id_venda) references vendas (id_venda);

alter table trocas
add constraint fk_trocas_vendas foreign key (id_venda) references vendas (id_venda);

alter table historico_vendas
add constraint fk_hist_vendas foreign key (id_venda) references vendas (id_venda);
go

create synonym dim_clientes for db_marketintel_crm.dbo.clientes;
create synonym dim_produtos for db_marketintel_produtos.dbo.produtos;
go
