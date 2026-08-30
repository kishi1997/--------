\timing on
\echo 'Week 3専用テーブルを作り直します'

drop table if exists index_lab_users;

-- emailへUNIQUEを付けると自動的にIndexが作られるため、実験用テーブルでは付けない。
create table index_lab_users (
  id bigint generated always as identity primary key,
  email text not null,
  status text not null,
  display_name text not null,
  created_at timestamptz not null
);

\echo '100万件を作成します'

insert into index_lab_users (email, status, display_name, created_at)
select
  'user' || n || '@example.com',
  case
    when n % 10 < 7 then 'active'
    when n % 10 < 9 then 'inactive'
    else 'pending'
  end,
  'User ' || n,
  current_timestamp
    - ((n % 730) * interval '1 day')
    - ((n % 86400) * interval '1 second')
from generate_series(1, 1000000) as n;

-- 大量INSERT後に統計情報を更新し、Query Plannerが正しく判断できるようにする。
analyze index_lab_users;

select count(*) as row_count from index_lab_users;
\echo '準備完了'

