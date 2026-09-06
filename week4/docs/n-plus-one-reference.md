# Week 4 N+1チートシート

## N+1とは

一覧を1回で取得し、各行の関連データをそれぞれ取得することで、SQLが`1 + N`回に増える問題です。

```text
SELECT users      1回
├─ SELECT posts  1回
├─ SELECT posts  1回
├─ SELECT posts  1回
└─ ...           N回
```

ORMの関連プロパティをループ内で読むと、見た目のコードが短くてもN+1になることがあります。

## 検出方法

- 同じ形のSQLがパラメータだけ変えて繰り返される
- 一覧の件数を増やすとSQL数も増える
- DBは速いのにアプリ全体は遅い
- APMやORMのクエリログで発行数が多い

## JOIN

```sql
select ...
from n1_users u
left join n1_posts p on p.user_id = u.id;
```

- SQL数を1回にできる
- 子が複数あると親の値が各行で重複する
- ページネーションではJOIN前に親を確定する工夫が必要

## Batching

```sql
select ... from n1_users where ...;
select ... from n1_posts where user_id = any($1::bigint[]);
```

- SQL数は基本的に2回
- 親と子のページネーションを分けやすい
- 取得後にアプリ側で関連付ける必要がある

## 判断の基準

```text
小さな1対多を1回で返す     JOIN
親子を別々制御したい       Batching
ループ内で関連を1件ずつ取得 N+1の疑い
```

JOINかBatchingかは、データ量、ページネーション、重複するデータ量、ネットワーク往復を実測して選びます。
