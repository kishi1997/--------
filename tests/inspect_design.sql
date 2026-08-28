\echo '=== カラム: 型・NULL可否・DEFAULT ==='

select
  table_name,
  ordinal_position as position,
  column_name,
  case
    when data_type = 'USER-DEFINED' then udt_name
    else data_type
  end as data_type,
  is_nullable as nullable,
  is_identity as identity,
  column_default as default_value
from information_schema.columns
where table_schema = 'public'
  and table_name in (
    'users', 'categories', 'products', 'orders', 'order_items', 'reviews'
  )
order by table_name, ordinal_position;

\echo '=== 制約: PRIMARY KEY・FOREIGN KEY・UNIQUE・CHECK ==='

select
  conrelid::regclass as table_name,
  conname as constraint_name,
  case contype
    when 'p' then 'PRIMARY KEY'
    when 'f' then 'FOREIGN KEY'
    when 'u' then 'UNIQUE'
    when 'c' then 'CHECK'
    else contype::text
  end as constraint_type,
  pg_get_constraintdef(oid) as constraint_definition
from pg_constraint
where connamespace = 'public'::regnamespace
  and conrelid::regclass::text in (
    'users', 'categories', 'products', 'orders', 'order_items', 'reviews'
  )
order by conrelid::regclass::text, constraint_type, constraint_name;
