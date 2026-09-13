# 課題5：購入Transaction

`purchaseProduct(productId, customerName)`を実装します。

必須条件：

1. `prisma.$transaction`を使う
2. `updateMany`で`stock > 0`のときだけ在庫を1減らす
3. 更新件数が0なら在庫切れエラーにする
4. 在庫減少と注文・明細作成を同じTransactionにする
5. 最後の1個へ同時購入しても注文を1件だけ作る

在庫更新が成功して注文作成が失敗した場合、在庫が元に戻ることも確認してください。
