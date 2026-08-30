# Database Learning

PostgreSQLの設計、制約、Index、N+1、Transactionを、実際のSQLと検証結果を残しながら学ぶリポジトリです。

## はじめ方

```bash
cp .env.example .env
make db-up
make psql
```

終了するときは次を実行します。DBデータはDocker volumeに残ります。

```bash
make db-down
```

## Week 2: Schema・Constraints

1. [SQL基本構文チートシート](docs/week2-sql-reference.md)を手元に開く
2. [課題とTips](schema/README.md)を読む
3. `schema/schema.sql`へ6テーブルを書く
4. `make verify`で構造を自己採点する
5. `schema/verification.sql`へ制約の検証を書く
6. [設計判断メモ](notes/design-decisions.md)へ理由と結果を残す

自分で考えたあとに比較できるよう、[模範解答](solutions/README.md)も最初から用意しています。模範解答は唯一の正解ではなく、削除ルールや重複条件を含む一つの設計例です。

`make verify`は、Docker内の学習用DBにある対象6テーブルを削除してから再作成します。本番DBや別のDBには使用しないでください。

制約の検証方法が分からないときは、先に次を実行してください。

```bash
make example
```

## よく使うコマンド

```bash
make help       # コマンド一覧
make apply      # schema.sqlを実行
make seed       # seed.sqlを実行
make verify     # テーブル構造を自己採点
make inspect    # 実際の型・制約・削除ルールを表示
make example    # 制約検証例を実行
make reference  # 模範解答を適用して構造テスト
make db-reset   # 学習用DBを完全初期化
```

## 学習ロードマップ

- Week 2: `schema/` - CREATE TABLE、制約、削除ルール
- Week 3: `indexes/` - EXPLAIN ANALYZE、Index、実測比較
- Week 4: `n-plus-one/` - ORM、N+1、JOIN、Batching
- Week 5: `transactions/` - Transaction、Lock、Concurrency
- Week 6: `app/` - Next.js、ORM、PostgreSQLの総合演習

## Week 3: Index・Query Performance

[Week 3課題](indexes/README.md)では、専用テーブルへ100万件を作り、`EXPLAIN (ANALYZE, BUFFERS)`でIndex追加前後を比較します。

```bash
make week3-setup
make week3-check
```

学習結果は[記録テンプレート](notes/result-template.md)を使い、推測ではなく実行結果を残します。

学習中に間違えて修正した内容は、[週ごとの修正ログ](logs/README.md)へ記録します。
