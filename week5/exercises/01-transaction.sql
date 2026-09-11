\echo '--- ROLLBACK: 更新を取り消す ---'
begin;
update tx_accounts set balance = balance - 200 where owner_name = '田中';
update tx_accounts set balance = balance + 200 where owner_name = '佐藤';
select * from tx_accounts order by id;
rollback;
select * from tx_accounts order by id;

\echo '--- COMMIT: 更新を確定する ---'
begin;
update tx_accounts set balance = balance - 200 where owner_name = '田中';
update tx_accounts set balance = balance + 200 where owner_name = '佐藤';
commit;
select * from tx_accounts order by id;
