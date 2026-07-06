.PHONY: help env-check compose-config up down ps logs health backup git-status

COMPOSE=docker compose -f infra/docker-compose.yml --env-file infra/.env

help:
	@echo "N3xus Video Factory commands"
	@echo ""
	@echo "make env-check       Validate required files"
	@echo "make compose-config  Validate Docker Compose"
	@echo "make up              Start stack"
	@echo "make down            Stop stack"
	@echo "make ps              Show containers"
	@echo "make logs            Show logs"
	@echo "make health          Run healthcheck script"
	@echo "make backup          Run backup script"
	@echo "make git-status      Show Git status"

env-check:
	@test -f infra/docker-compose.yml && echo "OK infra/docker-compose.yml" || (echo "MISSING infra/docker-compose.yml" && exit 1)
	@test -f infra/.env && echo "OK infra/.env" || (echo "MISSING infra/.env — copy infra/.env.example" && exit 1)

compose-config: env-check
	$(COMPOSE) config

up: compose-config
	$(COMPOSE) up -d

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs --tail=120

down:
	$(COMPOSE) down

health:
	bash scripts/healthcheck.sh

backup:
	bash scripts/backup.sh

git-status:
	git branch --show-current
	git status --short
