create database DB_MarketIntel_Vendas;
go

use DB_MarketIntel_Vendas;
go 

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

create table historico_vendas(
id_historico bigint identity(1,1) primary key,
id_venda bigint,
id_cliente bigint,
id_produto bigint,
valor_venda decimal(10,2),
data_venda datetime2 not null
);

create table trocas(
id_troca bigint identity(1,1) primary key,
id_cliente bigint,
id_venda bigint,
id_produto bigint,
quantidade_itens int,
id_produto_novo bigint,
quantidade_itens_novos int,
motivo_troca varchar(max),
lote_produto varchar(20),
data_venda datetime2 not null,
data_troca datetime2 default sysutcdatetime
);

go


alter table vendas
add constraint fk_vendas_pagamento foreign key (forma_pagamento) references forma_pagamento (id_forma_pagamento);

alter table vendas_lucros
add constraint fk_lucros_vendas foreign key (id_venda) references vendas (id_venda);

alter table trocas
add constraint fk_trocas_vendas foreign key (id_venda) references vendas (id_venda);

alter table historico_vendas
add constraint fk_hist_vendas foreign key (id_venda) references vendas (id_venda);

go

use db_marketintel_vendas;
go

create synonym dim_clientes for db_marketintel_crm.dbo.clientes;
create synonym dim_produtos for db_marketintel_produtos.dbo.produtos;
go
