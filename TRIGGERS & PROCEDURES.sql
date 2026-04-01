use db_marketintel_produtos;
go

create trigger trg_verificar_estoque_minimo
on produtos
after update
as
begin
    insert into produtos_em_falta (id_produto, quant_disponivel, id_fornecedor, custo_compra_unid)
    select i.id_produto, i.quant_disponivel, i.id_fornecedor, i.custo_compra_unid
    from inserted i
    where i.quant_disponivel <= 5
    and not exists (select 1 from produtos_em_falta where id_produto = i.id_produto);
end;
go

use db_marketintel_vendas;
go

create procedure sp_registrar_venda
    @id_cliente bigint,
    @id_produto bigint,
    @qtd int,
    @forma_pgto int
as
begin
    set nocount on;
    declare @preco decimal(10,2);
    
    select @preco = preco_produto from dim_produtos where id_produto = @id_produto;

    if @preco is not null
    begin
        insert into vendas (id_cliente, id_produto, quantidade_itens, valor_venda, forma_pagamento, status_venda)
        values (@id_cliente, @id_produto, @qtd, (@preco * @qtd), @forma_pgto, 'concluido');

        update dim_produtos 
        set quant_disponivel = quant_disponivel - @qtd
        where id_produto = @id_produto;
        
        print 'venda realizada e estoque atualizado!';
    end
    else
    begin
        raiserror('produto nao encontrado ou sem preco definido.', 16, 1);
    end
end;
go

use db_marketintel_pedidos;
go

create synonym dim_clientes for db_marketintel_crm.dbo.clientes;
create synonym dim_produtos for db_marketintel_produtos.dbo.produtos;
go

use db_marketintel_pedidos;
go

create trigger trg_calcular_lucro_pedido
on pedidos_ecom
after insert
as
begin
    insert into pedidose_lucros (id_pedido, valor_lucro_pedido)
    select 
        i.id_pedido,
        (i.valor_venda - (p.custo_compra_unid * i.quantidade_itens))
    from inserted i
    inner join dim_produtos p on i.id_produto = p.id_produto;
end;
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
