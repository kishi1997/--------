# 課題1：商品一覧

`app/src/lib/exercises.ts`の`getProducts()`を実装します。

条件は`active = true`、`stock > 0`、`price`昇順です。まずPrismaの`findMany`を調べ、自分で`where`と`orderBy`を書いてください。

確認項目：取得件数、先頭商品の価格、在庫0の商品が含まれないこと。
