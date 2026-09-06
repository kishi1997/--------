\timing on
\echo 'Week 4専用テーブルを作り直します'

drop table if exists n1_posts;
drop table if exists n1_users;

create table n1_users (
  id bigint generated always as identity primary key,
  name text not null,
  email text not null unique
);

create table n1_posts (
  id bigint generated always as identity primary key,
  user_id bigint not null references n1_users(id) on delete cascade,
  title text not null,
  published_at timestamptz not null default current_timestamp
);

insert into n1_users (name, email)
select 'User ' || n, 'week4-user' || n || '@example.com'
from generate_series(1, 100) as n;

insert into n1_posts (user_id, title, published_at)
select
  ((n - 1) % 80) + 1,
  'Post ' || n,
  current_timestamp - (n * interval '1 hour')
from generate_series(1, 2000) as n;

create index n1_posts_user_id_idx on n1_posts (user_id);
analyze n1_users;
analyze n1_posts;

\echo 'Week 4準備完了'
select count(*) as users from n1_users;
select count(*) as posts from n1_posts;
