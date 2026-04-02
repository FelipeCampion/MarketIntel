create database DB_MarketIntel_Pedidos;
go

use DB_MarketIntel_Pedidos;
go

create table pedidos_ecom(
id_pedido bigint identity(1,1) primary key,
id_cliente bigint,
valor_venda_total decimal(10,2) default 0,
endereco_entrega varchar(max),
taxa_entrega decimal(10,2),
forma_pagamento varchar(25),
data_entrega_prevista date not null,
data_pedido datetime2 default sysutcdatetime,
email_cliente varchar(100)
);

create table itens_pedido_ecom(
id_item_pedido bigint identity(1,1) primary key,
id_venda bigint not null,
id_produto bigint not null,
quantidade_itens int not null,
valor_unitario decimal(10,2) not null,
valor_subtotal as (quantidade_itens * valor_unitario)
);

create table pedidos_presenciais(
id_pedido bigint identity(1,1) primary key,
id_cliente bigint,
valor_venda_total decimal(10,2) default 0,
endereco_entrega varchar(max),
taxa_entrega decimal(10,2),
forma_pagamento varchar(25),
data_entrega_prevista date not null,
data_pedido datetime2 default sysutcdatetime,
email_cliente varchar(100)
);

create table itens_pedido_presenciais(
id_item_pedido bigint identity(1,1) primary key,
id_venda bigint not null,
id_produto bigint not null,
quantidade_itens int not null,
valor_unitario decimal(10,2) not null,
valor_subtotal as (quantidade_itens * valor_unitario)
);

create table pedidose_lucros(
id_lucro_ecom bigint identity(1,1) primary key,
id_pedido bigint,
valor_lucro_pedido decimal(10,2)
);

create table pedidosp_lucros(
id_lucro_presencial bigint identity(1,1) primary key,
id_pedido bigint,
valor_lucro_pedido decimal(10,2)
);

create table entregas_ecom(
id_entrega bigint identity(1,1) primary key,
id_pedido bigint,
data_entrega_realizada date not null,
codigo_entrega varchar(4),
status_entrega varchar(11)
);

create table entregas_presenciais(
id_entrega bigint identity(1,1) primary key,
id_pedido bigint,
data_entrega_realizada date not null,
codigo_entrega varchar(4),
status_entrega varchar(11)
);

create table historico_pedidos(
id_historico bigint identity(1,1) primary key,
id_pedido bigint,
id_cliente bigint,
valor_venda_total decimal(10,2),
data_venda datetime2 not null
);
go

alter table itens_pedido_ecom add constraint fk_itens_ecom_pai foreign key (id_venda) references pedidos_ecom (id_pedido);
alter table itens_pedido_presenciais add constraint fk_itens_presencial_pai foreign key (id_venda) references pedidos_presenciais (id_pedido);

alter table pedidose_lucros add constraint fk_lucro_pedido_ecom foreign key (id_pedido) references pedidos_ecom (id_pedido);
alter table pedidosp_lucros add constraint fk_lucro_pedido_presencial foreign key (id_pedido) references pedidos_presenciais (id_pedido);

alter table entregas_ecom add constraint fk_entrega_pedido_ecom foreign key (id_pedido) references pedidos_ecom (id_pedido);
alter table entregas_presenciais add constraint fk_entrega_pedido_presencial foreign key (id_pedido) references pedidos_presenciais (id_pedido);
go

create synonym dim_clientes for db_marketintel_crm.dbo.clientes;
create synonym dim_produtos for db_marketintel_produtos.dbo.produtos;
go
