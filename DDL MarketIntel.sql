create database MarketIntel;
go

use MarketIntel;
go

create table clientes(
id_cliente bigint identity(1,1) primary key,
nome varchar(100) not null,
data_nascimento date not null,
email varchar(100) not null unique,
ddd varchar(2),
telefone_celular varchar(9),
data_cadastro datetime2 default sysutcdatetime,
endereco_entrega varchar(200)
);

create table produtos(
id_produto bigint identity(1,1) primary key,
tipo_produto int,
fabricacao date not null,
validade date not null,
lote varchar(20) not null,
marca varchar(100) not null,
id_fornecedor bigint,
quant_disponivel int,
preco_produto decimal(10,2) not null,
custo_compra_unid decimal(10,2) not null,
v_lucro_venda decimal(10,2) not null,
n_nf_recebimento int not null
);

create table tipo(
id_tipo int identity(1,1) primary key,
nome_tipo varchar(50)
);

create table produto_tipo(
id_produto bigint,
id_tipo int,
primary key (id_produto, id_tipo)
);

create table fornecedores(
id_fornecedor bigint identity(1,1) primary key,
nome varchar(100) not null,
ddd int not null,
telefone_celular varchar(9),
email varchar(100) not null unique,
marca varchar(100) not null,
id_produto bigint,
tipo_produto int
);

create table fornecedores_produtos_tipos(
id_fornecedor bigint,
id_produto bigint,
id_tipo int,
primary key (id_fornecedor, id_produto, id_tipo)
);

create table produtos_em_falta(
id_falta int identity(1,1) primary key,
id_produto bigint,
quant_disponivel int,
id_fornecedor bigint,
custo_compra_unid decimal(10,2),
venda_media decimal(10,2),
quantidade_minima_estoque int
);

create table compra_produto(
id_compra int identity(1,1) primary key,
id_produto bigint,
id_tipo int,
id_fornecedor bigint,
custo_compra_unid decimal(10,2),
custo_compra_total decimal(10,2)
);

create table vendas(
id_venda bigint identity(1,1) primary key,
id_cliente bigint,
id_produto bigint,
quantidade_itens int,
valor_venda decimal(10,2),
data_venda datetime2 default sysutcdatetime,
forma_pagamento int,
status_venda varchar(20)
);

create table vendas_lucros(
id_venda bigint,
valor_lucro_venda decimal(10,2)
);

create table forma_pagamento(
id_forma_pagamento int identity(1,1) primary key,
nome_forma_pagamento varchar(25)
);

create table trocas(
id_troca bigint identity(1,1) primary key,
id_cliente bigint,
id_venda bigint,
id_produto bigint,
quantidade_itens int,
id_produto_novo bigint,
quantidade_itens_novos int,
motivo_troca text,
lote_produto varchar(20),
data_venda datetime2 not null,
data_troca datetime2 default sysutcdatetime
);

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

create table historico_vendas(
id_historico bigint identity(1,1) primary key,
id_venda bigint,
id_cliente bigint,
id_produto bigint,
valor_venda decimal(10,2),
data_venda datetime2 not null
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
-- faltam tabelas de contas a pagar, projeção de vendas, venda real do mes, historico de vendas/meses, metas de vendas por/mes

alter table produtos
add constraint fk_tipo_prod foreign key (tipo_produto) references tipo (id_tipo),
add constraint fk_forn_prod foreign key (id_fornecedor) references fornecedores (id_fornecedor);

alter table produto_tipo
add constraint fk_prod_pd foreign key (id_produto) references produtos (id_produto),
add constraint fk_tipo_pd foreign key (id_tipo) references tipo (id_tipo);

alter table fornecedores
add constraint fk_tipo_forn foreign key (id_tipo) references tipo (id_tipo);

alter table fornecedores_produtos_tipos
add constraint fk_for_fpt foreign key (id_fornecedor) references fornecedores (id_fornecedor),
add constraint fk_prod_fpt foreign key (id_produto) references produtos (id_produto),
add constraint fk_tip_fpt foreign key (id_tipo) references tipo (id_tipo);

alter table produtos_em_falta
add constraint fk_prod_pef foreign key (id_produto) references produtos (id_produto),
add constraint fk_for_pef foreign key (id_fornecedor) references fornecedores (id_fornecedor);

alter table compra_produto
add constraint fk_prod_cp foreign key (id_produto) references produtos (id_produto),
add constraint fk_tipo_cp foreign key (id_tipo) references tipo (id_tipo),
add constraint fk_for_cp foreign key (id_fornecedor) references fornecedores (id_fornecedor);

alter table vendas
add constraint fk_cliente_vend foreign key (id_cliente) references clientes (id_cliente),
add constraint fk_prod_vend foreign key (id_produto) references produtos (id_produto),
add constraint fk_formapag_vend foreign key (forma_pagamento) references forma_pagamento (id_forma_pagamento);

alter table vendas_lucros
add constraint fk_vend_vl foreign key (id_venda) references vendas (id_venda);

alter table trocas
add constraint fk_cliente_tro foreign key (id_cliente) references clientes (id_cliente),
add constraint fk_vend_tro foreign key (id_venda) references vendas (id_venda),
add constraint fk_prod_tro foreign key (id_produto) references produtos (id_produto),
add constraint fk_prodn_tro foreign key (id_produto_novo) references produtos (id_produto);

alter table pedidos_ecom
add constraint fk_cliente_pedie foreign key (id_cliente) references clientes (id_cliente),
add constraint fk_prod_pedie foreign key (id_produto) references produtos (id_produto),
add constraint fk_formapag_pedie foreign key (forma_pagamento) references forma_pagamento (id_forma_pagamento);

alter table pedidose_lucros
add constraint fk_ped_pedel foreign key (id_pedido) references pedidos_ecom (id_pedido);

alter table pedidosp_lucros
add constraint fk_ped_pedpl foreign key (id_pedido) references pedidos_presenciais (id_pedido);

alter table pedidos_presenciais
add constraint fk_cliente_pedip foreign key (id_cliente) references clientes (id_cliente),
add constraint fk_prod_pedip foreign key (id_produto) references produtos (id_produto),
add constraint fk_formapag_pedip foreign key (forma_pagamento) references forma_pagamento (id_forma_pagamento);

alter table entregas_ecom
add constraint fk_cliente_ente foreign key (id_cliente) references clientes (id_cliente),
add constraint fk_ped_ente foreign key (id_pedido) references pedidos_ecom (id_pedido),
add constraint fk_prod_ente foreign key (id_produto) references produtos (id_produto);

alter table entregas_presenciais
add constraint fk_cliente_entp foreign key (id_cliente) references clientes (id_cliente),
add constraint fk_ped_entp foreign key (id_pedido) references pedidos_presenciais (id_pedido),
add constraint fk_prod_entp foreign key (id_produto) references produtos (id_produto);


-- continuar as tabelas e dps fazer as triggers e as procedures de acordo


