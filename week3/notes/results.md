# Week 3 実測結果

実行時間は環境やキャッシュで変わります。数字だけでなく、実行計画が変わった理由を記録します。

## 実行環境

```text
PostgreSQL version:
実行日:
データ件数:
```

バージョン確認:

```sql
select version();
```

## 課題1: B-Tree

| 項目                   |              Before |               After |
| ---------------------- | ------------------: | ------------------: |
| Scan                   |   Parallel Seq Scan |          Index Scan |
| Planning Time          |            0.477 ms |            0.985 ms |
| Execution Time         |           25.556 ms |            0.214 ms |
| Rows Removed by Filter | 333333 × 3 ≒ 999999 |       0（表示なし） |
| Buffers                |    shared hit=11288 | shared hit=1 read=3 |

考察:
emailは100万件から1件を絞り込めるため、B-Tree Indexが有効だった。
Index作成前は約100万行を確認するParallel Seq Scanだったが、
作成後はemail用Indexから目的の1行を探すIndex Scanになった。
Execution Timeは25.556 msから0.214 msへ短縮され、
読み込むBuffersも11288から4ブロック相当まで減少した。

## 課題2: Selectivity

| 条件                 | 対象行の割合 | Scan                                 | Execution Time | なぜ？                                                                                                  |
| -------------------- | -----------: | ------------------------------------ | -------------: | ------------------------------------------------------------------------------------------------------- |
| `status = 'active'`  |        70.0% | Seq Scan                             |     128.818 ms | 70万件が該当するため、Index経由よりテーブル全体を順番に読む方が効率的と判断された                       |
| `status = 'pending'` |        10.0% | Bitmap Index Scan → Bitmap Heap Scan |     104.734 ms | 対象が10万件まで絞られるためIndexが使われた。件数が多いので、住所をBitmapにまとめてテーブル本体を読んだ |

## 課題3: Composite Index

| Index                  | Query条件           | Scan | Execution Time | 考察 |
| ---------------------- | ------------------- | ---- | -------------: | ---- |
| なし                   | status + created_at |      |                |      |
| `(status, created_at)` | status + created_at |      |                |      |
| `(status, created_at)` | created_atのみ      |      |                |      |
| `(created_at, status)` | status + created_at |      |                |      |

カラム順について説明:

## 課題4: Partial Index

| Index         | サイズ | Scan | Execution Time |
| ------------- | -----: | ---- | -------------: |
| Full Index    |        |      |                |
| Partial Index |        |      |                |

Partial Indexが使える条件:

## 課題5: Covering Index

| 項目           | Before | After |
| -------------- | -----: | ----: |
| Scan           |        |       |
| Heap Fetches   |        |       |
| Buffers        |        |       |
| Execution Time |        |       |

`INCLUDE`の役割:

## Week 3まとめ

```text
最も大きく変化したQuery:
作ったIndex:
なぜそのIndexが有効だったか:
Indexが使われなかった例:
Indexのデメリット:
```
