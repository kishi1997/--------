# Week 4: N+1・JOIN・Batching

アプリからPostgreSQLへ発行されるSQLを可視化し、N+1問題をJOINとBatchingで改善します。

Week 4では特定のORMに依存せず、Node.jsの`pg`を使います。ORMが内部で発行するSQLとクエリ数を、隠されていない状態で確認するためです。

## ゴール

- N+1が「1回の親取得 + N回の子取得」であると説明できる
- SQLログからN+1を発見できる
- JOINで1回、Batchingで2回へ改善できる
- JOINとBatchingの使い分けを説明できる
- 実行時間だけでなく、SQL数と取得行数を比較できる

## はじめ方

```bash
make db-up
npm install
make week4-setup
make week4-check
```

`week4-setup`はWeek 4専用の`n1_users`と`n1_posts`だけを作り直します。Week 2・3のテーブルには触れません。

## 課題

### 1. N+1を観察する

```bash
make week4-1
```

[01-n-plus-one.js](exercises/01-n-plus-one.js)は、20人のユーザーを取得した後、各1回ずつ投稿を取得する意図的に遅い実装です。

実行前にSQL数を予想してください。`SHOW_SQL=1 make week4-1`で全SQLを表示できます。

### 2. JOINで1回にする

[02-join.js](exercises/02-join.js)の`JOIN_SQL`を完成させます。

```bash
make week4-2
```

条件:

- 20人全員を返す
- 投稿がないユーザーも残す
- `n1_posts.user_id = n1_users.id`で結合する
- SQLは1回だけ発行する

### 3. Batchingで2回にする

[03-batching.js](exercises/03-batching.js)の`POSTS_SQL`を完成させます。

```bash
make week4-3
```

条件:

- 1回目のSQLでユーザー20人を取得する
- 2回目のSQLで20人分の投稿をまとめて取得する
- `ANY($1::bigint[])`を使う
- JavaScript側で投稿を`user_id`ごとにまとめる

### 4. 3パターンを比較する

自分で完成させた後に模範実装を実行します。

```bash
make week4-reference
```

実測結果と考察を[results.md](notes/results.md)へ記録してください。

## 見るポイント

```text
N+1       1 + N回。ユーザー数に比例してSQLが増える
JOIN      1回。親データが子の数だけ重複する
Batching  2回。親と子を別々にまとめて取得する
```

構文や考え方は[N+1チートシート](docs/n-plus-one-reference.md)を参照してください。

## 模範解答

最初から見ず、自分の実装と実測を終えてから[solutions](solutions/README.md)と比較してください。
