-- 課題5: Covering IndexとIndex Only Scan

-- emailで検索し、display_nameとcreated_atも返すクエリ。
explain (analyze, buffers)
select email, display_name, created_at
from index_lab_users
where display_name = 'user750000@example.com';

-- TODO 1: emailを検索キーにし、display_nameとcreated_atをINCLUDEするIndexを作る。
create index index_lab_users_email_covering_idx
on index_lab_users(email)
include(display_name,created_at);

create index index_lab_users_display_name_idx
on index_lab_users(display_name);
-- Index Only ScanにはVisibility Mapが関係するため、実験用テーブルをVACUUMする。
vacuum (analyze) index_lab_users;

-- TODO 2: 同じクエリを再実行する。
-- Index Only Scan、Heap Fetches、Buffersを確認する。

-- TODO 3: INCLUDEしたカラムがWHERE条件の検索キーとして使われるか考える。
検索キーとしては使われない、あくまで索引はindex登録したキーのみに有効
