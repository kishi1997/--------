drop table if exists tx_accounts;
create table tx_accounts (
  id bigint generated always as identity primary key,
  owner_name text not null unique,
  balance integer not null check (balance >= 0)
);
insert into tx_accounts (owner_name, balance)
values ('田中', 1000), ('佐藤', 1000);
