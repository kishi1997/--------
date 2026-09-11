select case
  when to_regclass('public.tx_accounts') is null then 'NG: tx_accountsがありません'
  when (select count(*) from tx_accounts) <> 2 then 'NG: 2口座ではありません'
  else 'OK: Week 5 setup complete'
end as result;
