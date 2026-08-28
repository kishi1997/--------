# Week 2 SQL基本構文チートシート

今週の`CREATE TABLE`、制約、検証で使うPostgreSQL構文をまとめています。

## CREATE TABLEの基本形

```sql
create table テーブル名 (
  カラム名 データ型 制約,
  カラム名 データ型 制約
);
```

例:

```sql
create table authors (
  id bigint generated always as identity primary key,
  name text not null,
  email text not null unique,
  created_at timestamptz not null default current_timestamp
);
```

最後のカラムにはカンマを付けません。

## 今週使うデータ型

| 型 | 用途 | 例 |
|---|---|---|
| `bigint` | 大きな整数、ID | `id bigint` |
| `integer` | 数量、在庫、評価 | `quantity integer` |
| `text` | 名前、本文、状態 | `name text` |
| `numeric(12, 2)` | 誤差を出したくない金額 | `price numeric(12, 2)` |
| `timestamptz` | タイムゾーン付き日時 | `created_at timestamptz` |

金額に`real`や`double precision`を使うと丸め誤差が出る可能性があります。

## PRIMARY KEYと自動採番

```sql
id bigint generated always as identity primary key
```

- `primary key`: 行を一意に識別する
- 自動的に`NOT NULL`と`UNIQUE`になる
- `generated always as identity`: IDをPostgreSQLが自動生成する

INSERT時はIDを書きません。

```sql
insert into authors (name, email)
values ('田中', 'tanaka@example.com');
```

## NOT NULL

値を必須にします。

```sql
name text not null
```

「まだ値が分からない」状態を許すなら付けません。

```sql
description text
```

空文字`''`と`NULL`は別物です。

## UNIQUE

重複を禁止します。

```sql
email text not null unique
```

複数カラムの組み合わせを一意にする場合:

```sql
constraint favorites_user_book_key unique (user_id, book_id)
```

この例では、同じユーザーと本の組み合わせを2回登録できません。

## DEFAULT

値を省略したときの初期値を設定します。

```sql
created_at timestamptz not null default current_timestamp
```

```sql
status text not null default 'pending'
```

`DEFAULT`は、明示的に`NULL`を入れた場合には使われません。

## CHECK

値が条件を満たすか検査します。

```sql
price numeric(12, 2) not null check (price >= 0)
```

範囲を制限する場合:

```sql
score integer not null check (score between 1 and 5)
```

許可する文字列を制限する場合:

```sql
status text not null
  check (status in ('draft', 'published', 'archived'))
```

## FOREIGN KEY

別テーブルに存在する行だけを参照できるようにします。

```sql
create table books (
  id bigint generated always as identity primary key,
  author_id bigint not null,
  title text not null,
  constraint books_author_id_fkey
    foreign key (author_id)
    references authors(id)
);
```

読み方:

```text
books.author_id → authors.id
子の外部キー        親の主キー
```

短く書くこともできます。

```sql
author_id bigint not null references authors(id)
```

学習中は制約名と関係が見やすい、長い書き方がおすすめです。

## ON DELETE

親の行を削除したとき、子をどう扱うか決めます。

| 設定 | 動作 | 向いている場面 |
|---|---|---|
| `on delete restrict` | 子があれば親を削除させない | 注文履歴などを守りたい |
| `on delete cascade` | 親と一緒に子も削除する | 親なしでは意味がない明細など |
| `on delete set null` | 子の外部キーを`NULL`にする | 子を残したいが関連は外せる |

```sql
foreign key (author_id)
references authors(id)
on delete restrict
```

`SET NULL`を使うカラムには`NOT NULL`を付けられません。

```sql
author_id bigint,
foreign key (author_id)
  references authors(id)
  on delete set null
```

## 名前付き制約

制約へ名前を付けると、エラーや後からの変更が分かりやすくなります。

```sql
constraint books_price_check check (price >= 0)
```

よく使う命名例:

```text
テーブル_カラム_fkey
テーブル_カラム_check
テーブル_カラム_key
```

## テーブル作成順

外部キーの参照先が先に存在する必要があるため、親から作ります。

```text
1. 外部キーを持たない親テーブル
2. 親を参照する子テーブル
3. 複数テーブルを参照する中間・明細テーブル
```

削除するときは逆順です。

```sql
drop table if exists books;
drop table if exists authors;
```

## ALTER TABLE

作成後にカラムや制約を変更します。

```sql
alter table books
add column published_at timestamptz;
```

```sql
alter table books
add constraint books_price_check check (price >= 0);
```

```sql
alter table books
drop constraint books_price_check;
```

```sql
alter table books
rename column old_name to new_name;
```

## INSERTで制約を検証する

正常値と異常値の両方を試します。

```sql
begin;

-- 正常値: 成功することを確認
insert into sample_scores (score) values (5);

-- 境界外: CHECK違反になることを確認
insert into sample_scores (score) values (6);

rollback;
```

`ROLLBACK`すれば検証用データを残さずに済みます。途中でエラーになるとTransactionは失敗状態になるため、最後に`ROLLBACK`してください。

## DELETE動作を検証する

```sql
begin;

delete from authors where id = 1;

-- 子が残ったか、一緒に消えたか、削除が拒否されたか確認
select * from books where author_id = 1;

rollback;
```

## psqlで確認する

```text
\dt                 テーブル一覧
\d users            usersのカラムと制約
\d+ users           より詳しい情報
\i schema/schema.sql SQLファイルを実行
\q                  psqlを終了
```

このプロジェクトでは、次のコマンドでも確認できます。

```bash
make apply      # 自分のschema.sqlを実行
make verify     # 作り直して必須構造を自己採点
make inspect    # 型・NULL・DEFAULT・制約を一覧表示
make reference  # 模範解答を適用
```

## よくあるエラー

### カンマの不足・付けすぎ

```text
ERROR: syntax error at or near ...
```

各カラムの末尾と、最後のカラムに余計なカンマがないか確認します。

### 親テーブルがない

```text
ERROR: relation "authors" does not exist
```

参照先の親テーブルを先に作ります。

### 外部キー違反

```text
ERROR: violates foreign key constraint
```

親テーブルに存在しないIDを子へ登録しようとしています。

### CHECK違反

```text
ERROR: violates check constraint
```

INSERTした値と`CHECK (...)`の条件を確認します。

