# Week 2 修正ログ

CREATE TABLEと制約の学習中に行った修正を記録します。

## 同じユーザーによる同一商品へのレビューを1回に制限

### 間違い・不足

`reviews`テーブルに、同じ`user_id`と`product_id`の組み合わせを複数登録できる状態だった。

### 修正方法

2カラムの組み合わせに`UNIQUE`制約を追加する。

```sql
alter table reviews
add constraint reviews_user_product_id_key
unique (user_id, product_id);
```

`user_id`だけを`UNIQUE`にすると、ユーザーが全商品を通して1件しかレビューできなくなる。今回は`user_id`と`product_id`の組み合わせを対象にする。

### 確認方法

同じユーザーと商品の組み合わせを2回INSERTし、2回目が`UNIQUE`違反になることを確認する。

```sql
select user_id, product_id, count(*)
from reviews
group by user_id, product_id
having count(*) > 1;
```

既存データを持つテーブルへ制約を追加する場合は、上のSQLで重複がないことを先に確認する。

### 学んだこと

複数カラムの組み合わせを重複禁止にする場合は、複合`UNIQUE`制約を使う。

## ratingの範囲を0〜5から1〜5へ変更

### 間違い・不足

`reviews.rating`の`CHECK`制約が、0を許可する条件になっていた。

```sql
check (rating between 0 and 5)
```

### 修正方法

PostgreSQLでは既存の`CHECK`条件を直接書き換えられないため、一度制約を削除してから作り直す。

```sql
alter table reviews
drop constraint reviews_rating_check;

alter table reviews
add constraint reviews_rating_check
check (rating between 1 and 5);
```

### 確認方法

制約を追加する前に、変更後の条件に違反する既存データがないか確認する。

```sql
select *
from reviews
where rating not between 1 and 5;
```

修正後は、`rating = 1`と`rating = 5`が登録でき、`rating = 0`と`rating = 6`が`CHECK`違反になることを確認する。

制約定義はpsqlでも確認できる。

```text
\d reviews
```

### 学んだこと

既存の`CHECK`条件を変更するときは、対象データを確認してから`DROP CONSTRAINT`と`ADD CONSTRAINT`で作り直す。

