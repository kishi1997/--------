-- 課題3: Composite Indexとカラム順

-- 対象クエリ: statusは等価条件、created_atは範囲条件。
explain (analyze, buffers)
select id, status, created_at
from index_lab_users
where status = 'pending'
  and created_at >= current_timestamp - interval '30 days';

-- TODO 1: (status, created_at)の複合Indexを作る。
-- 等価条件のカラムを先、範囲条件のカラムを後にする。

-- TODO 2: 対象クエリを再実行し、変化を記録する。

-- TODO 3: statusを使わず、created_atだけで検索する。
explain (analyze, buffers)
select id, status, created_at
from index_lab_users
where created_at >= current_timestamp - interval '30 days';

-- TODO 4: 複合Indexがcreated_at単独検索で有効か確認する。
-- 左端のstatusを使わない場合に何が起きたか説明する。

-- TODO 5: 逆順の(created_at, status)も試し、対象クエリと
-- created_at単独クエリでどちらが使われるか比較する。

