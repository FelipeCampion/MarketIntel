create DB_MarketIntel_CRM;
go

use DB_MarketIntel_CRM;
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

go
