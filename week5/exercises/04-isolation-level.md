# 課題4: Isolation Level

## READ COMMITTED

1. Aで`BEGIN ISOLATION LEVEL READ COMMITTED;`を実行して残高を読む
2. Bで残高を更新して`COMMIT;`する
3. Aでもう一度読み、値が変わることを確認する

## REPEATABLE READ

1. `make week5-setup`後、Aで`BEGIN ISOLATION LEVEL REPEATABLE READ;`を実行して残高を読む
2. Bで残高を更新して`COMMIT;`する
3. Aでもう一度読み、同じ値が見えることを確認する
4. Aで`COMMIT;`後に読み、Bの更新が見えることを確認する
