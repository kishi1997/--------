\echo '1/4 テーブルの存在を確認'

do $$
declare
  target_table text;
begin
  foreach target_table in array array[
    'users', 'categories', 'products', 'orders', 'order_items', 'reviews'
  ] loop
    if to_regclass('public.' || target_table) is null then
      raise exception 'NG: テーブル % がありません', target_table;
    end if;
  end loop;
end $$;

\echo '2/4 カラムの存在を確認'

do $$
declare
  expected record;
begin
  for expected in
    select * from (values
      ('users', 'id'), ('users', 'name'), ('users', 'email'), ('users', 'created_at'),
      ('categories', 'id'), ('categories', 'name'), ('categories', 'created_at'),
      ('products', 'id'), ('products', 'category_id'), ('products', 'name'),
      ('products', 'description'), ('products', 'price'), ('products', 'stock'),
      ('products', 'created_at'),
      ('orders', 'id'), ('orders', 'user_id'), ('orders', 'total_amount'),
      ('orders', 'status'), ('orders', 'created_at'),
      ('order_items', 'id'), ('order_items', 'order_id'), ('order_items', 'product_id'),
      ('order_items', 'unit_price'), ('order_items', 'quantity'),
      ('reviews', 'id'), ('reviews', 'user_id'), ('reviews', 'product_id'),
      ('reviews', 'title'), ('reviews', 'content'), ('reviews', 'rating'),
      ('reviews', 'created_at')
    ) as required_columns(table_name, column_name)
  loop
    if not exists (
      select 1
      from information_schema.columns c
      where c.table_schema = 'public'
        and c.table_name = expected.table_name
        and c.column_name = expected.column_name
    ) then
      raise exception 'NG: %.% カラムがありません', expected.table_name, expected.column_name;
    end if;
  end loop;
end $$;

\echo '3/4 主キーを確認'

do $$
declare
  target_table text;
begin
  foreach target_table in array array[
    'users', 'categories', 'products', 'orders', 'order_items', 'reviews'
  ] loop
    if not exists (
      select 1
      from information_schema.table_constraints tc
      where tc.table_schema = 'public'
        and tc.table_name = target_table
        and tc.constraint_type = 'PRIMARY KEY'
    ) then
      raise exception 'NG: テーブル % にPRIMARY KEYがありません', target_table;
    end if;
  end loop;
end $$;

\echo '4/4 外部キーを確認'

do $$
declare
  expected record;
begin
  for expected in
    select * from (values
      ('products', 'category_id', 'categories', 'id'),
      ('orders', 'user_id', 'users', 'id'),
      ('order_items', 'order_id', 'orders', 'id'),
      ('order_items', 'product_id', 'products', 'id'),
      ('reviews', 'user_id', 'users', 'id'),
      ('reviews', 'product_id', 'products', 'id')
    ) as required_fks(child_table, child_column, parent_table, parent_column)
  loop
    if not exists (
      select 1
      from information_schema.table_constraints tc
      join information_schema.key_column_usage kcu
        on tc.constraint_name = kcu.constraint_name
       and tc.constraint_schema = kcu.constraint_schema
      join information_schema.constraint_column_usage ccu
        on tc.constraint_name = ccu.constraint_name
       and tc.constraint_schema = ccu.constraint_schema
      where tc.constraint_type = 'FOREIGN KEY'
        and tc.table_schema = 'public'
        and tc.table_name = expected.child_table
        and kcu.column_name = expected.child_column
        and ccu.table_name = expected.parent_table
        and ccu.column_name = expected.parent_column
    ) then
      raise exception 'NG: %.% -> %.% のFOREIGN KEYがありません',
        expected.child_table,
        expected.child_column,
        expected.parent_table,
        expected.parent_column;
    end if;
  end loop;
end $$;

\echo 'OK: 必須のテーブル、カラム、主キー、外部キーを確認できました'
