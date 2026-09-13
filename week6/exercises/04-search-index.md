# 課題4：検索とIndex

`searchProducts(keyword)`を実装し、商品名の部分一致検索を行います。

実装後、PostgreSQLで`EXPLAIN (ANALYZE, BUFFERS)`を実行し、少量データではIndexが選ばれない場合がある理由も記録してください。発展課題では検索方法に合うIndexを検討します。
