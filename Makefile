.PHONY: help env-check compose-config bootstrap-n8n bootstrap-gpt-gateway gateway-ps gateway-logs up down ps logs health backup git-status

COMPOSE=docker compose -f infra/docker-compose.yml --env-file infra/.env
COMPOSE_GATEWAY=docker compose -f infra/docker-compose.yml -f infra/docker-compose.gpt-gateway.yml --env-file infra/.env

help:
	@echo "N3xus Video Factory commands"
	@echo ""
	@echo "make bootstrap-n8n         One-command n8n stack bootstrap"
	@echo "make bootstrap-gpt-gateway One-command GPT gateway bootstrap"
	@echo "make env-check             Validate required files"
	@echo "make compose-config        Validate Docker Compose"
	@echo "make up                    Start stack"
	@echo "make down                  Stop stack"
	@echo "make ps                    Show containers"
	@echo "make logs                  Show logs"
	@echo "make gateway-ps            Show GPT gateway container"
	@echo "make gateway-logs          Show GPT gateway logs"
	@echo "make health                Run healthcheck script"
	@echo "make backup                Run backup script"
	@echo "make git-status            Show Git status"

bootstrap-n8n:
	bash scripts/bootstrap-n8n-video-factory.sh

bootstrap-gpt-gateway:
	bash scripts/bootstrap-gpt-n8n-gateway.sh

gateway-ps:
	$(COMPOSE_GATEWAY) ps n8n-gpt-gateway

gateway-logs:
	$(COMPOSE_GATEWAY) logs --tail=120 n8n-gpt-gateway

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
