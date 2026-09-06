\echo 'Week 4の準備を確認します'

do $$
declare
  user_count bigint;
  post_count bigint;
begin
  if to_regclass('public.n1_users') is null then
    raise exception 'NG: n1_usersがありません。make week4-setupを実行してください';
  end if;

  if to_regclass('public.n1_posts') is null then
    raise exception 'NG: n1_postsがありません。make week4-setupを実行してください';
  end if;

  select count(*) into user_count from n1_users;
  select count(*) into post_count from n1_posts;

  if user_count <> 100 then
    raise exception 'NG: n1_usersは100件ではありません: %件', user_count;
  end if;

  if post_count <> 2000 then
    raise exception 'NG: n1_postsは2000件ではありません: %件', post_count;
  end if;

  if not exists (
    select 1 from pg_indexes
    where schemaname = 'public'
      and tablename = 'n1_posts'
      and indexname = 'n1_posts_user_id_idx'
  ) then
    raise exception 'NG: n1_posts_user_id_idxがありません';
  end if;
end $$;

select
  (select count(*) from n1_users) as users,
  (select count(*) from n1_posts) as posts,
  (select count(distinct user_id) from n1_posts) as users_with_posts;

\echo 'OK: Week 4の実験を開始できます'
