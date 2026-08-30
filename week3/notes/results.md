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

| 項目 | Before | After |
|---|---:|---:|
| Scan |  |  |
| Planning Time |  |  |
| Execution Time |  |  |
| Rows Removed by Filter |  |  |
| Buffers |  |  |

考察:

## 課題2: Selectivity

| 条件 | 対象行の割合 | Scan | Execution Time | なぜ？ |
|---|---:|---|---:|---|
| `status = 'active'` |  |  |  |  |
| `status = 'pending'` |  |  |  |  |

## 課題3: Composite Index

| Index | Query条件 | Scan | Execution Time | 考察 |
|---|---|---|---:|---|
| なし | status + created_at |  |  |  |
| `(status, created_at)` | status + created_at |  |  |  |
| `(status, created_at)` | created_atのみ |  |  |  |
| `(created_at, status)` | status + created_at |  |  |  |

カラム順について説明:

## 課題4: Partial Index

| Index | サイズ | Scan | Execution Time |
|---|---:|---|---:|
| Full Index |  |  |  |
| Partial Index |  |  |  |

Partial Indexが使える条件:

## 課題5: Covering Index

| 項目 | Before | After |
|---|---:|---:|
| Scan |  |  |
| Heap Fetches |  |  |
| Buffers |  |  |
| Execution Time |  |  |

`INCLUDE`の役割:

## Week 3まとめ

```text
最も大きく変化したQuery:
作ったIndex:
なぜそのIndexが有効だったか:
Indexが使われなかった例:
Indexのデメリット:
```

