drop table if exists tx_accounts;
drop table if exists tx_orders;
drop table if exists tx_products;

create table tx_accounts (
  id bigint generated always as identity primary key,
  owner_name text not null unique,
  balance integer not null check (balance >= 0)
);
insert into tx_accounts (owner_name, balance)
values ('田中', 1000), ('佐藤', 1000);

create table tx_products (
  id bigint generated always as identity primary key,
  name text not null unique,
  stock integer not null check (stock >= 0)
);

create table tx_orders (
  id bigint generated always as identity primary key,
  product_id bigint not null references tx_products(id),
  buyer_name text not null,
  created_at timestamptz not null default now()
);

insert into tx_products (name, stock)
values ('最後の限定商品', 1);
