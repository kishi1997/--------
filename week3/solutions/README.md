# Week 3 模範解答

[reference-indexes.sql](reference-indexes.sql)にIndex作成例があります。

最初から丸写しせず、各課題で次の順番を守ってください。

1. 実行計画を予想する
2. Indexなしで計測する
3. 自分でIndexを書く
4. 同じQueryを再計測する
5. 模範解答と比較する

実行時間とScan種類は環境やデータ分布によって変わります。模範解答の中心はIndexの定義と、その理由です。

## 判断理由

- email検索は100万件から1件を探すため、B-Treeの単一Indexが向く
- statusだけでは多くの行が一致するため、IndexがあってもSeq Scanが合理的な場合がある
- `status = ... AND created_at >= ...`では、等価条件のstatusを先にする
- pendingだけを頻繁に調べるならPartial Indexで対象行を減らせる
- emailで検索して名前と日時だけ返すなら、`INCLUDE`でIndex Only Scanを狙える

