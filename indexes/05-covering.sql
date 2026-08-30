-- 課題5: Covering IndexとIndex Only Scan

-- emailで検索し、display_nameとcreated_atも返すクエリ。
explain (analyze, buffers)
select email, display_name, created_at
from index_lab_users
where email = 'user750000@example.com';

-- TODO 1: emailを検索キーにし、display_nameとcreated_atをINCLUDEするIndexを作る。

-- Index Only ScanにはVisibility Mapが関係するため、実験用テーブルをVACUUMする。
vacuum (analyze) index_lab_users;

-- TODO 2: 同じクエリを再実行する。
-- Index Only Scan、Heap Fetches、Buffersを確認する。

-- TODO 3: INCLUDEしたカラムがWHERE条件の検索キーとして使われるか考える。

