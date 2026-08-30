# Week 3 Index・EXPLAINチートシート

## Indexとは

テーブル全体を先頭から探さず、目的の行を見つけやすくするための別構造です。本の索引に似ています。

Indexには読み取りを速くする可能性がある一方、ディスク容量を使い、`INSERT / UPDATE / DELETE`時にIndexも更新するコストがあります。

## B-Tree Index

PostgreSQLで`CREATE INDEX`の種類を省略するとB-Treeになります。

```sql
create index index_lab_users_email_idx
on index_lab_users (email);
```

B-Treeが得意な条件:

```text
=  <  <=  >  >=  BETWEEN  IN  IS NULL
```

## Indexの削除

```sql
drop index if exists index_lab_users_email_idx;
```

## EXPLAINとEXPLAIN ANALYZE

```sql
explain
select * from index_lab_users where email = 'user1@example.com';
```

`EXPLAIN`はPlannerが選んだ実行計画を表示します。クエリ自体は実行しません。

```sql
explain analyze
select * from index_lab_users where email = 'user1@example.com';
```

`EXPLAIN ANALYZE`はクエリを実際に実行し、実測時間を表示します。

今週はBuffersも確認します。

```sql
explain (analyze, buffers)
select * from index_lab_users where email = 'user1@example.com';
```

注意: `EXPLAIN ANALYZE DELETE ...`や`UPDATE ...`は実際にデータを変更します。

## 実行計画で見る場所

| 表示 | 意味 |
|---|---|
| `Seq Scan` | テーブルを先頭から順番に調べる |
| `Index Scan` | Indexで行を探し、テーブルから行を取得する |
| `Index Only Scan` | 必要な値をIndexから取得できる |
| `Bitmap Index Scan` | 複数行をまとめて取得するときに使われることがある |
| `cost` | Plannerによる相対的な予測値。ミリ秒ではない |
| `rows` | 予測行数または実際の行数 |
| `actual time` | 実際にかかった時間 |
| `loops` | その処理を繰り返した回数 |
| `Rows Removed by Filter` | 読んだ後に条件で捨てた行数 |
| `Buffers` | データをメモリ・ディスクから何ブロック読んだか |
| `Planning Time` | 実行計画を作る時間 |
| `Execution Time` | クエリ全体の実行時間 |

## Selectivity

条件がデータをどれくらい絞れるかを表します。

```text
100万件から1件       高いSelectivity → Index向き
100万件から70万件    低いSelectivity → Seq Scanの方が速い場合がある
```

Indexが存在しても、必ずIndex Scanになるわけではありません。

## Composite Index

複数カラムを組み合わせたIndexです。

```sql
create index index_lab_users_status_created_at_idx
on index_lab_users (status, created_at);
```

基本的には、等価条件を先、範囲条件を後に置きます。

```sql
where status = 'pending'
  and created_at >= current_timestamp - interval '30 days'
```

```text
(status, created_at)
 等価条件   範囲条件
```

B-Treeの複合Indexは左端から使うのが基本です。

```text
(status, created_at)

statusだけ                   使いやすい
status + created_at          使いやすい
created_atだけ               効率的に使えない場合が多い
```

## Partial Index

条件に一致する行だけをIndexへ入れます。

```sql
create index index_lab_users_pending_created_at_idx
on index_lab_users (created_at)
where status = 'pending';
```

Indexが小さくなりますが、クエリ側にもPartial Indexの条件が必要です。

## Covering Index

検索に使わないが、結果として返したいカラムを`INCLUDE`します。

```sql
create index index_lab_users_email_covering_idx
on index_lab_users (email)
include (display_name, created_at);
```

条件次第で`Index Only Scan`が可能になります。`INCLUDE`したカラムは検索キーではありません。

## 統計情報

Plannerはテーブルの統計情報を使って実行計画を決めます。大量データを追加した後は更新します。

```sql
analyze index_lab_users;
```

## Index一覧とサイズ

```sql
select
  indexname,
  pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size,
  indexdef
from pg_indexes
where schemaname = 'public'
  and tablename = 'index_lab_users';
```

## よくある誤解

```text
Indexがある = 必ず使われる             誤り
Execution Timeは毎回同じ                誤り
costはミリ秒                            誤り
Indexは多いほど良い                     誤り
PRIMARY KEYとUNIQUEにはIndexが作られる  正しい
外部キーには自動でIndexが作られる       誤り
```

