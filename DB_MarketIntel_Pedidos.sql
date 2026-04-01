create database DB_MarketIntel_Pedidos;
go

use DB_MarketIntel_Pedidos;
go

create table pedidos_ecom(
id_pedido bigint identity(1,1) primary key,
id_cliente bigint,
id_produto bigint,
quantidade_itens int,
valor_venda decimal(10,2),
endereco_entrega text,
taxa_entrega decimal(10,2),
forma_pagameno varchar(25),
data_entrega_prevista date not null,
data_pedido datetime2 default sysutcdatetime,
email_cliente varchar(100)
);

create table pedidos_presenciais(
id_pedido bigint identity(1,1) primary key,
id_cliente bigint,
id_produto bigint,
quantidade_itens int,
valor_venda decimal(10,2),
endereco_entrega text,
taxa_entrega decimal(10,2),
forma_pagameno varchar(25),
data_entrega_prevista date not null,
data_pedido datetime2 default sysutcdatetime,
email_cliente varchar(100)
);

create table pedidose_lucros(
id_pedido bigint,
valor_lucro_pedido decimal(10,2)
);

create table pedidosp_lucros(
id_pedido bigint,
valor_lucro_pedido decimal(10,2)
);

create table entregas_ecom(
id_entrega bigint identity(1,1) primary key,
id_cliente bigint,
id_pedido bigint,
id_produto bigint,
valor_venda decimal(10,2),
endereco_entrega text,
taxa_entrega decimal(10,2),
data_entrega_realizada date not null,
codigo_entrega varchar(4),
status_entrega varchar(11)
);

create table entregas_presenciais(
id_entrega bigint identity(1,1) primary key,
id_cliente bigint,
id_pedido bigint,
id_produto bigint,
valor_venda decimal(10,2),
endereco_entrega text,
taxa_entrega decimal(10,2),
data_entrega_realizada date not null,
codigo_entrega varchar(4),
status_entrega varchar(11)
);

create table historico_pedidos(
id_historico bigint identity(1,1) primary key,
id_pedido bigint,
id_cliente bigint,
id_produto bigint,
valor_venda decimal(10,2),
data_venda datetime2 not null
);

go

alter table pedidose_lucros
add constraint fk_lucro_pedido_ecom foreign key (id_pedido) references pedidos_ecom (id_pedido);

alter table pedidosp_lucros
add constraint fk_lucro_pedido_presencial foreign key (id_pedido) references pedidos_presenciais (id_pedido);

alter table entregas_ecom
add constraint fk_entrega_pedido_ecom foreign key (id_pedido) references pedidos_ecom (id_pedido);

alter table entregas_presenciais
add constraint fk_entrega_pedido_presencial foreign key (id_pedido) references pedidos_presenciais (id_pedido);

alter table historico_pedidos
add constraint fk_hist_pedido_ecom foreign key (id_pedido) references pedidos_ecom (id_pedido);

go
