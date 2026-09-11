select case
  when to_regclass('public.tx_accounts') is null then 'NG: tx_accountsがありません'
  when (select count(*) from tx_accounts) <> 2 then 'NG: 2口座ではありません'
  else 'OK: Week 5 setup complete'
end as result;

select case
  when to_regclass('public.tx_products') is null then 'NG: tx_productsがありません'
  when to_regclass('public.tx_orders') is null then 'NG: tx_ordersがありません'
  when (select stock from tx_products where id = 1) <> 1 then 'NG: 在庫が1ではありません'
  else 'OK: 在庫実験 setup complete'
end as result;
