-- Week 2: ER図をもとに6テーブルを作成する。
-- 親テーブルから順番にCREATE TABLEを書く。

-- TODO 1: users
create table users (
    id bigint generated always as identity primary key,
    name text not null,
    email text not null unique,
    created_at timestamptz not null default current_timestamp
);
-- TODO 2: categories
create table categories (
    id integer generated always as identity primary key,
    name text not null,
    created_at timestamptz not null default current_timestamp
);
-- TODO 3: products
create table products (
    id bigint generated always as identity primary key,
    category_id integer not null,
    name text not null,
    description text not null,
    price numeric(12, 2) not null,
    stock integer not null,
    created_at timestamptz not null default current_timestamp,
    constraint category_product_id_fkey 
      foreign key (category_id)
      references categories(id)
);
-- TODO 4: orders
create table orders (
    id bigint generated always as  identity primary key,
    user_id bigint not null,
    total_amount numeric(12, 2) not null,
    status text not null,
    created_at timestamptz not null default current_timestamp,
    constraint orders_status_check 
      check (status in('pending', 'paid', 'shipped', 'canceled')),
    constraint orders_user_id_fkey
      foreign key(user_id)
      references users(id)
);
-- TODO 5: order_items
create table order_items (
    id bigint generated always as identity primary key,
    order_id bigint not null,
    product_id bigint not null,
    unit_price numeric(12,2),
    quantity integer not null,
    created_at timestamptz not null default current_timestamp,
    constraint order_items_orders_fkey
      foreign key (order_id)
      references orders(id),
    constraint order_items_products_fkey
      foreign key (product_id)
      references products(id)
);
-- TODO 6: reviews
create table reviews (
    id bigint generated always as identity primary key,
    user_id bigint not null,
    product_id bigint not null,
    title text not null,
    content text not null,
    rating integer not null check(rating between 1 and 5),
    created_at timestamptz not null default current_timestamp,
    constraint reviews_users_id_fkey
      foreign key (user_id)
      references users(id),
    constraint reviews_products_id_fkey
      foreign key (product_id)
      references products(id),
    constraint reviews_user_product_id_key
      unique(user_id, product_id)
);
