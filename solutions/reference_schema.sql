-- 今回のER図に対する模範解答の一例。
-- 制約やON DELETEには複数の正解があるため、理由とセットで比較する。

create table users (
  id bigint generated always as identity primary key,
  name text not null,
  email text not null unique,
  created_at timestamptz not null default current_timestamp
);

create table categories (
  id bigint generated always as identity primary key,
  name text not null unique,
  created_at timestamptz not null default current_timestamp
);

create table products (
  id bigint generated always as identity primary key,
  category_id bigint not null,
  name text not null,
  description text,
  price numeric(12, 2) not null check (price >= 0),
  stock integer not null default 0 check (stock >= 0),
  created_at timestamptz not null default current_timestamp,
  constraint products_category_id_fkey
    foreign key (category_id)
    references categories(id)
    on delete restrict
);

create table orders (
  id bigint generated always as identity primary key,
  user_id bigint not null,
  total_amount numeric(12, 2) not null check (total_amount >= 0),
  status text not null default 'pending'
    check (status in ('pending', 'paid', 'shipped', 'cancelled')),
  created_at timestamptz not null default current_timestamp,
  constraint orders_user_id_fkey
    foreign key (user_id)
    references users(id)
    on delete restrict
);

create table order_items (
  id bigint generated always as identity primary key,
  order_id bigint not null,
  product_id bigint not null,
  unit_price numeric(12, 2) not null check (unit_price >= 0),
  quantity integer not null check (quantity > 0),
  constraint order_items_order_product_key unique (order_id, product_id),
  constraint order_items_order_id_fkey
    foreign key (order_id)
    references orders(id)
    on delete cascade,
  constraint order_items_product_id_fkey
    foreign key (product_id)
    references products(id)
    on delete restrict
);

create table reviews (
  id bigint generated always as identity primary key,
  user_id bigint not null,
  product_id bigint not null,
  title text not null,
  content text not null,
  rating integer not null check (rating between 1 and 5),
  created_at timestamptz not null default current_timestamp,
  constraint reviews_user_product_key unique (user_id, product_id),
  constraint reviews_user_id_fkey
    foreign key (user_id)
    references users(id)
    on delete cascade,
  constraint reviews_product_id_fkey
    foreign key (product_id)
    references products(id)
    on delete cascade
);
