-- 課題1: B-Treeと単一カラムIndex
-- 実行前に make week3-setup を実行する。

-- TODO 1: Indexがない状態で、次のクエリがSeq Scanになると予想する。
-- Scan種類、Rows Removed by Filter、Execution Time、Buffersを記録する。
explain (analyze, buffers)
select *
from index_lab_users
where email = 'user750000@example.com';

-- TODO 2: emailにB-Tree Indexを作る。
-- create indexの構文は自分で書く。

-- TODO 3: 同じEXPLAIN ANALYZEを再実行する。
-- Index Scanになったか、時間とBuffersがどう変わったかを記録する。

-- TODO 4: 作成されたIndexとサイズを確認する。
select
  indexname,
  indexdef,
  pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
from pg_indexes
where schemaname = 'public'
  and tablename = 'index_lab_users'
order by indexname;

