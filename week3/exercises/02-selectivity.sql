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
create index index_lab_users_status_idx
on index_lab_users(status);
status = 'active'の数が70万件もあるから、seq scanの方が効率よくできると判断されるはず
-- TODO 4: pendingでも比較する。
explain (analyze, buffers)
select *
from index_lab_users
where status = 'pending';

-- TODO 5: activeとpendingでPlannerの判断が違う場合、その理由を書く。
activeは70%を占めていたため、indexするよりseq scanの方が効率よくできると判断されたが、
pendingは対象が全体の10%なのでstatus用Indexが使われた。ただしpendingの行が
テーブル全体に散らばっており、テーブル本体の11,288ブロックを読む必要があったため、大幅な高速化にはならなかった。

active：対象が多い
        ↓
Indexを使わず全体を読む
        ↓
Seq Scan

pending：対象が比較的少ない
         ↓
Indexで住所を探す
         ↓
住所をブロック単位にまとめる
         ↓
Bitmap Index Scan → Bitmap Heap Scan
