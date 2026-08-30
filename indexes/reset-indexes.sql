-- Week 3で作るIndexを削除し、PRIMARY KEY Indexだけの状態へ戻す。

drop index if exists index_lab_users_email_idx;
drop index if exists index_lab_users_status_idx;
drop index if exists index_lab_users_status_created_at_idx;
drop index if exists index_lab_users_created_at_status_idx;
drop index if exists index_lab_users_pending_created_at_idx;
drop index if exists index_lab_users_email_covering_idx;

analyze index_lab_users;
