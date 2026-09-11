# 課題3: 行ロック

最初に`make week5-setup`を実行します。

1. Aで`BEGIN;`後、`SELECT * FROM tx_accounts WHERE id = 1 FOR UPDATE;`を実行する
2. Bでも同じ2文を実行し、待機することを確認する
3. Aで残高を更新して`COMMIT;`する
4. Bの待機が解除され、Aの更新後の値を読めることを確認する
5. Bでも更新し、`COMMIT;`する
