-- 課題4: Partial Index
-- pending行だけを対象にする小さなIndexを検討する。

-- TODO 1: 全statusを含む複合Indexのサイズを確認する。

-- TODO 2: pendingだけを含むPartial Indexを作る。
-- created_atをIndex対象にし、WHERE status = 'pending'をIndex定義へ付ける。

-- TODO 3: 次のクエリでPartial Indexが使われるか確認する。
explain (analyze, buffers)
select id, status, created_at
from index_lab_users
where status = 'pending'
  and created_at >= current_timestamp - interval '30 days';

-- TODO 4: activeへ条件を変え、Partial Indexが使われないことを確認する。
explain (analyze, buffers)
select id, status, created_at
from index_lab_users
where status = 'active'
  and created_at >= current_timestamp - interval '30 days';

-- TODO 5: Full IndexとPartial Indexのサイズを比較し、使える条件を説明する。
select
  indexname,
  pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size,
  indexdef
from pg_indexes
where schemaname = 'public'
  and tablename = 'index_lab_users'
order by indexname;

