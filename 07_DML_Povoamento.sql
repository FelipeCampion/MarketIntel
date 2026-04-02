use db_marketintel_crm;
go
insert into clientes (nome, data_nascimento, email, ddd, telefone_celular, endereco_entrega)
values 
('felipe campion', '1995-05-15', 'felipe@email.com', '19', '999998888', 'rua do sql, 123'),
('ana silva', '1990-10-20', 'ana.silva@email.com', '11', '988887777', 'av paulista, 1000'),
('jose oliveira', '1985-03-12', 'jose.o@email.com', '21', '977776666', 'rua das flores, 50');
go

use db_marketintel_produtos;
go
insert into tipo (nome_tipo) values ('perifericos'), ('hardware'), ('monitores');

insert into fornecedores (nome, ddd, email, marca) 
values 
('tech supply', '11', 'contato@tech.com', 'logitech'),
('power parts', '41', 'vendas@power.com', 'corsair');

insert into produtos (tipo_produto, fabricacao, validade, lote, marca, id_fornecedor, quant_disponivel, preco_produto, custo_compra_unid, v_lucro_venda, n_nf_recebimento)
values 
(1, '2026-01-01', '2029-01-01', 'lote_001', 'logitech', 1, 50, 250.00, 150.00, 100.00, 1010),
(2, '2026-02-15', '2030-01-01', 'lote_h05', 'corsair', 2, 20, 800.00, 550.00, 250.00, 1011);
go

use db_marketintel_vendas;
go
insert into forma_pagamento (nome_forma_pagamento) values ('Cartao Credito'), ('Boleto'), ('Pix');

exec sp_registrar_venda @id_cliente = 1, @id_produto = 1, @qtd = 2, @forma_pgto = 1;
exec sp_registrar_venda @id_cliente = 2, @id_produto = 2, @qtd = 1, @forma_pgto = 2;
go

use db_marketintel_pedidos;
go
insert into pedidos_ecom (id_cliente, endereco_entrega, taxa_entrega, forma_pagamento, data_entrega_prevista, email_cliente)
values (1, 'rua do sql, 123', 15.00, 'Cartao Credito', '2026-04-10', 'felipe@email.com');

declare @id_pedido_criado bigint = scope_identity();

insert into itens_pedido_ecom (id_venda, id_produto, quantidade_itens, valor_unitario)
values 
(@id_pedido_criado, 1, 1, 250.00),
(@id_pedido_criado, 2, 1, 800.00);

update pedidos_ecom 
set valor_venda_total = (select sum(valor_subtotal) from itens_pedido_ecom where id_venda = @id_pedido_criado)
where id_pedido = @id_pedido_criado;
go

use db_marketintel_financeiro;
go
insert into metas_vendas (id_tipo_produto, mes_referencia, ano_referencia, valor_meta_faturamento, qtd_meta_itens)
values (1, 4, 2026, 5000.00, 20); 

exec sp_gerar_fechamento_mensal @mes = 4, @ano = 2026;
go
