-- 課題1: emailを完全一致検索するB-Tree Index
create index index_lab_users_email_idx
on index_lab_users (email);

-- 課題2: Selectivity比較用
create index index_lab_users_status_idx
on index_lab_users (status);

-- 課題3: 等価条件を先、範囲条件を後にする複合Index
create index index_lab_users_status_created_at_idx
on index_lab_users (status, created_at);

-- カラム順比較用。両方を本番で残すという意味ではない。
create index index_lab_users_created_at_status_idx
on index_lab_users (created_at, status);

-- 課題4: pending行だけを対象にするPartial Index
create index index_lab_users_pending_created_at_idx
on index_lab_users (created_at)
where status = 'pending';

-- 課題5: 検索キー以外のSELECT対象を含めるCovering Index
create index index_lab_users_email_covering_idx
on index_lab_users (email)
include (display_name, created_at);

