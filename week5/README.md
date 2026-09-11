# Week 5: Transaction・Concurrency

複数のSQLを安全にまとめるTransactionと、同時実行時にデータを守るLock・Isolation Levelを、2つのpsql画面を使って観察します。

## ゴール

- `BEGIN`・`COMMIT`・`ROLLBACK`の役割を説明できる
- 同時更新でLost Updateが起きる理由を説明できる
- `SELECT ... FOR UPDATE`で更新対象を守れる
- Isolation Levelによって見えるデータが変わることを確認できる

## 最初に見る図解

![TransactionとSnapshot](docs/transaction-and-snapshot.png)

Transactionは処理を囲む範囲、Snapshotはその範囲から見えるデータの状態です。

## はじめ方

```bash
make db-up
make week5-setup
make week5-check
```

課題2以降はターミナルを2つ開き、両方で`make psql`を実行します。

## 課題

### 1. COMMITとROLLBACKを観察する

![COMMITとROLLBACK](docs/01-transaction-flow.png)

複数の更新が「全部成功」または「全部取り消し」になることを確認します。

```bash
make week5-1
```

### 2. Lost Updateを再現する

![Lost Update](docs/02-lost-update.png)

2つの接続が同じ残高を読み、それぞれ更新すると、一方の変更が消える流れを観察します。

[課題手順](exercises/02-lost-update.md)

### 3. 行ロックで更新を守る

![行ロック](docs/03-row-lock.png)

`SELECT ... FOR UPDATE`で、先に更新しているTransactionが終わるまで後続処理を待たせます。

[課題手順](exercises/03-row-lock.md)

### 4. Isolation Levelを比較する

![Isolation Level](docs/04-isolation-level.png)

`READ COMMITTED`と`REPEATABLE READ`で、同じTransaction内の再読結果がどう変わるか比較します。

[課題手順](exercises/04-isolation-level.md)

## 記録

実験前の予想と結果を[results.md](notes/results.md)へ記録してください。
