# 課題6：最後の1個を2人が同時購入

## ゴール

在庫1個の商品へ2人が同時購入しても、成功する注文が1件だけになることを確認します。

最初に`make week5-setup`を実行し、ターミナルA・Bの両方で`make psql`を実行します。

## ターミナルA

```sql
begin;

update tx_products
set stock = stock - 1
where id = 1 and stock > 0
returning stock;
```

まだ`COMMIT`しないで、ターミナルBへ進みます。

## ターミナルB

同じSQLを実行します。Aが終了していないため待機します。

```sql
begin;

update tx_products
set stock = stock - 1
where id = 1 and stock > 0
returning stock;
```

## Aを確定する

```sql
insert into tx_orders (product_id, buyer_name) values (1, '購入者A');
commit;
```

Bの待機が解除されます。Bの`UPDATE`は0行になります。購入失敗として取り消します。

```sql
rollback;
```

## 最終確認

```sql
select * from tx_products;
select * from tx_orders;
```

期待結果は`stock = 0`、注文は購入者Aの1件だけです。
