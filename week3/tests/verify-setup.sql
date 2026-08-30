\echo 'Week 3の準備を確認します'

do $$
declare
  actual_count bigint;
begin
  if to_regclass('public.index_lab_users') is null then
    raise exception 'NG: index_lab_usersがありません。make week3-setupを実行してください';
  end if;

  select count(*) into actual_count from index_lab_users;

  if actual_count <> 1000000 then
    raise exception 'NG: データ件数が100万件ではありません: %件', actual_count;
  end if;
end $$;

select
  count(*) as row_count,
  pg_size_pretty(pg_relation_size('index_lab_users')) as table_size,
  pg_size_pretty(pg_total_relation_size('index_lab_users')) as total_size
from index_lab_users;

select status, count(*)
from index_lab_users
group by status
order by status;

select indexname, indexdef
from pg_indexes
where schemaname = 'public'
  and tablename = 'index_lab_users'
order by indexname;

\echo 'OK: Week 3の実験を開始できます'

