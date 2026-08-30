# Week 3: Index・Query Performance

100万件のデータを使い、Index追加前後の実行計画と実測値を比較します。

## ゴール

「Indexを作れば速くなる」ではなく、次を説明できる状態を目指します。

- なぜこのクエリにこのIndexを作るのか
- なぜIndexがあっても`Seq Scan`になることがあるのか
- 複合Indexでカラム順が重要なのはなぜか
- Partial IndexとCovering Indexをいつ使うのか
- `cost`ではなく`actual time`と`buffers`をどう読むか

## はじめ方

構文を確認するときは、[Week 3 Indexチートシート](../docs/week3-index-reference.md)を開いてください。

PostgreSQLを起動し、専用テーブルへ100万件を作成します。

```bash
make db-up
make week3-setup
```

`week3-setup`は`index_lab_users`だけを削除して作り直します。Week 2の6テーブルには触れません。

準備を確認します。

```bash
make week3-check
```

## 課題

課題ファイルを番号順に進めます。

1. [B-Treeと単一カラムIndex](01-btree.sql)
2. [Selectivity](02-selectivity.sql)
3. [Composite Indexとカラム順](03-composite.sql)
4. [Partial Index](04-partial.sql)
5. [Covering Index](05-covering.sql)

各ファイルの`TODO`へSQLと予想を書き、実行結果を[results.md](results.md)へ記録します。

課題ファイルを編集してから、対応するコマンドで実行します。

```bash
make week3-1
make week3-2
make week3-3
make week3-4
make week3-5
```

SQLを1つずつ確認したい場合は、`make psql`で接続して貼り付けても構いません。

## 実験の基本手順

```text
1. 実行計画を予想する
2. EXPLAIN (ANALYZE, BUFFERS)を実行する
3. Scan種類・actual time・rows・Buffersを記録する
4. Indexを追加または変更する
5. 同じクエリをもう一度実行する
6. なぜ変わったかを自分の言葉で書く
```

キャッシュによって時間が変わるため、同じクエリを3回程度実行し、代表値または中央値を記録してください。時間だけでなく実行計画の変化を重視します。

## リセット

自分で作ったWeek 3用Indexだけを削除する場合:

```bash
make week3-reset-indexes
```

100万件を含めて最初からやり直す場合:

```bash
make week3-setup
```

## 模範解答

自分で試したあと、[Week 3模範解答](../solutions/week3/README.md)と比較してください。実行時間はPC、キャッシュ、PostgreSQLの判断によって変わるため、模範解答と同じ数字になる必要はありません。
