.PHONY: help db-up db-down db-reset psql apply seed verify inspect example reference week3-setup week3-check week3-reset-indexes week3-1 week3-2 week3-3 week3-4 week3-5 week4-setup week4-check week4-1 week4-2 week4-3 week4-reference

WEEK2 := week2
WEEK3 := week3
WEEK4 := week4
PSQL := docker compose exec -T postgres sh -c 'psql -v ON_ERROR_STOP=1 -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"'
NODE_RUN := set -a; if [ -f .env ]; then . ./.env; fi; set +a; node

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
	@echo "make week4-setup         N+1実験用データを作成"
	@echo "make week4-check         Week 4の準備状態を確認"
	@echo "make week4-1             N+1実装を実行"
	@echo "make week4-2             JOIN課題を実行"
	@echo "make week4-3             Batching課題を実行"
	@echo "make week4-reference     3パターンの模範実装を比較"

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

week4-setup:
	@echo "注意: n1_usersとn1_postsを削除し、実験データで作り直します"
	$(PSQL) < $(WEEK4)/exercises/setup.sql
	$(MAKE) week4-check

week4-check:
	$(PSQL) < $(WEEK4)/tests/verify-setup.sql

week4-1:
	@$(NODE_RUN) $(WEEK4)/exercises/01-n-plus-one.js

week4-2:
	@$(NODE_RUN) $(WEEK4)/exercises/02-join.js

week4-3:
	@$(NODE_RUN) $(WEEK4)/exercises/03-batching.js

week4-reference:
	@$(NODE_RUN) $(WEEK4)/solutions/reference.js
