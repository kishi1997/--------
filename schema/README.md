# Week 2: CREATE TABLEと制約

ER図をもとに、次の6テーブルを自分で作成してください。

## テーブルとカラム

```text
users
  id, name, email, created_at

categories
  id, name, created_at

products
  id, category_id, name, description, price, stock, created_at

orders
  id, user_id, total_amount, status, created_at

order_items
  id, order_id, product_id, unit_price, quantity

reviews
  id, user_id, product_id, title, content, rating, created_at
```

元のER図から、課題文にあった`reviews.rating`を追加し、`products.desc`は意味が伝わりやすい`description`へ変更しています。

## 作成順

参照される親テーブルから作ります。

```text
users       categories
  |              |
orders        products
  |           /    |
  +-> order_items  reviews <- users
```

## 今日決めること

- 各主キーをどう自動生成するか
- どのカラムで`NULL`を禁止するか
- メールアドレスやカテゴリ名など、どこで重複を禁止するか
- 金額、在庫、数量、評価値にどんな`CHECK`を付けるか
- `orders.status`に許可する値をどう制限するか
- 同じユーザーが同じ商品へ複数レビューできるか
- 親レコード削除時に`CASCADE`、`RESTRICT`、`SET NULL`のどれを使うか

答えだけでなく、[設計判断メモ](../notes/design-decisions.md)へ理由を書いてください。

## PostgreSQL Tips

- 主キー候補: `bigint generated always as identity primary key`
- 金額候補: 誤差のない`numeric(12, 2)`
- 日時候補: タイムゾーンを保持する`timestamptz`
- 可変長文字列: 長さ制限が業務ルールでなければ`text`
- 時刻の初期値候補: `default current_timestamp`
- 名前は小文字の`snake_case`に統一する
- PostgreSQLは外部キーカラムのIndexを自動作成しない

Week 2では制約に集中します。外部キーIndexの効果はWeek 3で`EXPLAIN ANALYZE`を使って確認します。

## 自己検証

構造の必須部分は次で確認できます。

```bash
make verify
```

自動確認する内容:

- 6テーブルが存在する
- 指定されたカラムが存在する
- 全テーブルに主キーがある
- ER図どおりの外部キーがある

さらに、`make inspect`で現在の設計を一覧表示できます。

```bash
make inspect
```

表示された`nullable`、`default`、`constraint_definition`を、自分が[設計判断メモ](../notes/design-decisions.md)へ書いた内容と照合してください。

`NOT NULL`、`UNIQUE`、`CHECK`、削除ルールには設計上の選択肢があります。これらは`schema/verification.sql`に、自分が意図した正常値と異常値をINSERT・DELETEして検証します。

