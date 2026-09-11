# 課題2: Lost Update

最初に`make week5-setup`で残高を戻し、ターミナルA・Bの両方で`make psql`を実行します。

1. AとBで`BEGIN;`を実行する
2. 両方で`SELECT balance FROM tx_accounts WHERE id = 1;`を実行し、1000を読む
3. Aで`UPDATE tx_accounts SET balance = 900 WHERE id = 1;`を実行して`COMMIT;`
4. Bで`UPDATE tx_accounts SET balance = 800 WHERE id = 1;`を実行して`COMMIT;`
5. 最終残高を確認し、Aの変更が残っているか考える
