# 課題2：ページネーション

`getProductPage(page, pageSize)`を実装します。

```text
skip = (page - 1) × pageSize
```

商品取得と`count`を行い、`{ products, total, totalPages }`を返してください。ページ1と2で同じ商品が出ないことを確認します。
