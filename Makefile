.PHONY: help db-up db-down db-reset psql apply seed verify inspect example reference

help:
	@echo "make db-up     PostgreSQLを起動"
	@echo "make psql      psqlへ接続"
	@echo "make apply     schema/schema.sqlを実行"
	@echo "make seed      schema/seed.sqlを実行"
	@echo "make verify    6テーブルを再作成して構造を自己採点"
	@echo "make inspect   現在の型・制約・削除ルールを一覧表示"
	@echo "make example   制約検証のサンプルを実行"
	@echo "make reference 模範解答を学習用DBへ適用して検証"
	@echo "make db-down   PostgreSQLを停止"
	@echo "make db-reset  DBボリュームを削除して初期化"

db-up:
	docker compose up -d --wait

db-down:
	docker compose down

db-reset:
	@echo "学習用DBの全データを削除します"
	docker compose down -v
	docker compose up -d --wait

psql:
	docker compose exec postgres sh -c 'psql -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"'

apply:
	docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < schema/schema.sql

seed:
	docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < schema/seed.sql

verify:
	@echo "注意: 学習用DBの users/categories/products/orders/order_items/reviews を削除して再作成します"
	docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < tests/reset.sql
	$(MAKE) apply
	docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < tests/verify_structure.sql
	$(MAKE) inspect

inspect:
	docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < tests/inspect_design.sql

example:
	docker compose exec -T postgres sh -c 'psql -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < examples/constraint_check.sql

reference:
	@echo "注意: 学習用DBの対象6テーブルを模範解答で作り直します"
	docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < tests/reset.sql
	docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < solutions/reference_schema.sql
	docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"' < tests/verify_structure.sql
	$(MAKE) inspect
