-- 課題2: Selectivity
-- Selectivityは「条件でどれくらい行を絞れるか」を表す。

-- TODO 1: statusごとの件数と割合を確認する。
select
  status,
  count(*) as rows,
  round(count(*) * 100.0 / sum(count(*)) over (), 1) as percentage
from index_lab_users
group by status
order by status;

-- TODO 2: statusにIndexを作る前の実行計画を確認する。
explain (analyze, buffers)
select *
from index_lab_users
where status = 'active';

-- TODO 3: statusだけのIndexを作り、同じクエリを再実行する。
-- Indexが存在してもSeq Scanが選ばれる可能性がある。結果を予想してから試す。

-- TODO 4: pendingでも比較する。
explain (analyze, buffers)
select *
from index_lab_users
where status = 'pending';

-- TODO 5: activeとpendingでPlannerの判断が違う場合、その理由を書く。

