create database db_marketintel_produtos;
go

use db_marketintel_produtos;
go

create table tipo(
id_tipo int identity(1,1) primary key,
nome_tipo varchar(50)
);

create table produtos(
id_produto bigint identity(1,1) primary key,
tipo_produto int,
fabricacao date not null,
validade date not null,
lote varchar(20) not null,
marca varchar(100) not null,
quant_disponivel int,
preco_produto decimal(10,2) not null,
custo_compra_unid decimal(10,2) not null,
v_lucro_venda decimal(10,2) not null,
n_nf_recebimento int not null
);

create table fornecedores(
id_fornecedor bigint identity(1,1) primary key,
nome varchar(100) not null,
ddd varchar(2) not null,
telefone_celular varchar(9),
email varchar(100) not null unique,
marca varchar(100) not null
);

create table produtos_fornecedores(
id_produto_fornecedor bigint identity(1,1) primary key,
id_produto bigint not null,
id_fornecedor bigint not null,
custo_compra_especifico decimal(10,2),
prazo_entrega_dias int,
data_ultima_compra datetime2
);

create table produtos_em_falta(
id_falta int identity(1,1) primary key,
id_produto bigint,
quant_disponivel int,
id_fornecedor_sugerido bigint,
custo_compra_unid decimal(10,2),
venda_media decimal(10,2),
quantidade_minima_estoque int
);

go

alter table produtos
add constraint fk_prod_tipo foreign key (tipo_produto) references tipo (id_tipo);

alter table produtos_fornecedores
add constraint fk_pf_produto foreign key (id_produto) references produtos (id_produto),
add constraint fk_pf_fornecedor foreign key (id_fornecedor) references fornecedores (id_fornecedor);

alter table produtos_em_falta
add constraint fk_pef_prod foreign key (id_produto) references produtos (id_produto),
add constraint fk_pef_forn foreign key (id_fornecedor_sugerido) references fornecedores (id_fornecedor);

go
