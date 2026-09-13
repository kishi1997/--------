# 課題3：注文履歴とN+1

`getOrdersWithItems()`を実装します。各注文の`items`と、各明細の`product`を`include`してください。

ループ内で注文ごと、明細ごとに追加クエリを呼ばないことが条件です。生成されたSQLをPrismaのクエリログで確認します。
