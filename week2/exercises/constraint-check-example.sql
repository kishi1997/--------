\echo '一時テーブルでCHECK制約の検証方法を確認します'

begin;

create temporary table example_reviews (
  id bigint generated always as identity primary key,
  rating integer not null check (rating between 1 and 5)
);

\echo '正常例: rating = 5 は成功する'
insert into example_reviews (rating) values (5);

\echo '異常例: rating = 6 はCHECK違反になる'
\set ON_ERROR_STOP off
insert into example_reviews (rating) values (6);
\set ON_ERROR_STOP on

rollback;

\echo '検証終了: ROLLBACKしたためデータと一時テーブルは残りません'

