-- 課題3: Composite Indexとカラム順

-- 対象クエリ: statusは等価条件、created_atは範囲条件。
explain (analyze, buffers)
select id, status, created_at
from index_lab_users
where status = 'pending'
  and created_at >= current_timestamp - interval '30 days';

-- TODO 1: (status, created_at)の複合Indexを作る。
-- 等価条件のカラムを先、範囲条件のカラムを後にする。
create index index_lab_users_created_at_status_idx
on index_lab_users (created_at,status);

-- TODO 2: 対象クエリを再実行し、変化を記録する。
Indexなし:
Parallel Seq Scan / 60.693 ms / Buffers 11,288

(status, created_at):
Bitmap Index Scan → Bitmap Heap Scan
6.267 ms / Buffers 1,538

-- TODO 3: statusを使わず、created_atだけで検索する。
explain (analyze, buffers)
select id, status, created_at
from index_lab_users
where created_at >= current_timestamp - interval '30 days';

-- TODO 4: 複合Indexがcreated_at単独検索で有効か確認する。
-- 左端のstatusを使わない場合に何が起きたか説明する。

-- TODO 5: 逆順の(created_at, status)も試し、対象クエリと
-- created_at単独クエリでどちらが使われるか比較する。

created_at単独検索では、created_atが左端にある
(created_at, status)の複合Indexが選択された。

直近30日の範囲をIndexから探せるため、
(status, created_at)しかない場合のParallel Seq Scanと比べて、
Execution TimeとBuffersが大幅に減少した。

複合Indexは、検索条件で使用するカラムが
左端にあるかどうかによって利用効率が変わる。
