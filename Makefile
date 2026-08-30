.PHONY: help db-up db-down db-reset psql apply seed verify inspect example reference week3-setup week3-check week3-reset-indexes week3-1 week3-2 week3-3 week3-4 week3-5

WEEK2 := week2
WEEK3 := week3
PSQL := docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"'

help:
	@echo "make db-up     PostgreSQLを起動"
	@echo "make psql      psqlへ接続"
	@echo "make apply     week2/exercises/schema.sqlを実行"
	@echo "make seed      week2/exercises/seed.sqlを実行"
	@echo "make verify    6テーブルを再作成して構造を自己採点"
	@echo "make inspect   現在の型・制約・削除ルールを一覧表示"
	@echo "make example   制約検証のサンプルを実行"
	@echo "make reference 模範解答を学習用DBへ適用して検証"
	@echo "make db-down   PostgreSQLを停止"
	@echo "make db-reset  DBボリュームを削除して初期化"
	@echo "make week3-setup         Index実験用100万件を作成"
	@echo "make week3-check         Week 3の準備状態を確認"
	@echo "make week3-reset-indexes Week 3で作ったIndexを削除"
	@echo "make week3-1〜week3-5   各課題SQLを実行"

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
	$(PSQL) < $(WEEK2)/exercises/schema.sql

seed:
	$(PSQL) < $(WEEK2)/exercises/seed.sql

verify:
	@echo "注意: 学習用DBの users/categories/products/orders/order_items/reviews を削除して再作成します"
	$(PSQL) < $(WEEK2)/tests/reset.sql
	$(MAKE) apply
	$(PSQL) < $(WEEK2)/tests/verify_structure.sql
	$(MAKE) inspect

inspect:
	$(PSQL) < $(WEEK2)/tests/inspect_design.sql

example:
	$(PSQL) < $(WEEK2)/exercises/constraint-check-example.sql

reference:
	@echo "注意: 学習用DBの対象6テーブルを模範解答で作り直します"
	$(PSQL) < $(WEEK2)/tests/reset.sql
	$(PSQL) < $(WEEK2)/solutions/reference-schema.sql
	$(PSQL) < $(WEEK2)/tests/verify_structure.sql
	$(MAKE) inspect

week3-setup:
	@echo "注意: index_lab_usersを削除し、100万件で作り直します"
	$(PSQL) < $(WEEK3)/exercises/setup.sql
	$(MAKE) week3-check

week3-check:
	$(PSQL) < $(WEEK3)/tests/verify-setup.sql

week3-reset-indexes:
	$(PSQL) < $(WEEK3)/exercises/reset-indexes.sql

week3-1:
	$(PSQL) < $(WEEK3)/exercises/01-btree.sql

week3-2:
	$(PSQL) < $(WEEK3)/exercises/02-selectivity.sql

week3-3:
	$(PSQL) < $(WEEK3)/exercises/03-composite.sql

week3-4:
	$(PSQL) < $(WEEK3)/exercises/04-partial.sql

week3-5:
	$(PSQL) < $(WEEK3)/exercises/05-covering.sql
