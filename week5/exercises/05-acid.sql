\echo '--- Consistency: 在庫をマイナスにできない ---'
do $$
begin
  update tx_products set stock = -1 where id = 1;
exception
  when check_violation then
    raise notice 'CHECK制約がstock < 0を拒否しました';
end
$$;

select id, name, stock from tx_products;

\echo '--- Atomicity + Durability: 在庫減少と注文作成をまとめて確定 ---'
begin;
update tx_products
set stock = stock - 1
where id = 1 and stock > 0;

insert into tx_orders (product_id, buyer_name)
values (1, '購入者A');
commit;

select id, name, stock from tx_products;
select id, product_id, buyer_name from tx_orders;
