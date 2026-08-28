-- 自分が決めた制約が実際に動くか確認する。
-- BEGINとROLLBACKで囲むと、検証データをDBへ残さず試せる。

begin;

-- TODO: 正常なデータがINSERTできること

-- TODO: NOT NULLに違反するデータが拒否されること

-- TODO: UNIQUEに違反するデータが拒否されること

-- TODO: CHECKの境界値と範囲外の値を確認すること

-- TODO: 親をDELETEしたとき、子が意図した動作になること

rollback;

