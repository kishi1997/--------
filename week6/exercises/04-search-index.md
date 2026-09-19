# 課題4：検索とIndex

`searchProducts(keyword)`を実装し、商品名の部分一致検索を行います。

実装後、PostgreSQLで`EXPLAIN (ANALYZE, BUFFERS)`を実行し、少量データではIndexが選ばれない場合がある理由も記録してください。発展課題では検索方法に合うIndexを検討します。

検索条件：
name ILIKE '%限定ターゲット%'

Index追加前の実行計画：
Seq Scan

B-tree追加後の実行計画：
Seq Scan

GIN Index追加後の実行計画：
Bitmap Index Scan + Bitmap Heap Scan

Plannerが選んだ方法と理由：
先頭が%の部分一致検索ではB-treeを使いにくい。
pg_trgmのGIN Indexは文字列の部分一致検索に対応できる。

Indexなし：
Execution Time = 57.942 ms

B-tree：
Execution Time = 58.629 ms

GIN：
Execution Time = 0.697 ms
