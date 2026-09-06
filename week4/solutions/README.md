# Week 4 模範解答

[reference.js](reference.js)は、同じユーザー20人と投稿500件を次の3通りで取得します。

| 方法 | SQL数 | 要点 |
|---|---:|---|
| N+1 | 21 | 親を1回、子を20回 |
| JOIN | 1 | `LEFT JOIN`で一括取得 |
| Batching | 2 | `ANY($1::bigint[])`で子をまとめて取得 |

```bash
make week4-reference
```

実行時間はキャッシュやPCの状態で変わります。この課題では時間の小さだけでなく、ユーザー数が増えてもSQL数が増えない設計かを重視します。

## JOINの要点

```sql
with selected_users as (
  select id, name, email
  from n1_users
  order by id
  limit 20
)
select ...
from selected_users u
left join n1_posts p on p.user_id = u.id;
```

`LIMIT`をJOIN後にかけると「20人」ではなく「JOIN後の20行」になるため、先に親を確定します。

## Batchingの要点

```sql
where user_id = any($1::bigint[])
```

N個のIDを1回のSQLへ渡し、取得後にアプリ側で`user_id`ごとに整理します。DataLoaderなどのバッチ処理も同じ考え方です。
