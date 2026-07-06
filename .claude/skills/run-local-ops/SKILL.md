---
description: Executa comandos locais padronizados de operação: Makefile, Taskfile, healthcheck, Compose e logs.
allowed-tools: Read Bash
---

# Run Local Ops

Use esta skill para operar a stack localmente.

## Comandos preferenciais

```bash
make env-check
make compose-config
make up
make ps
make logs
make health
```

## Sem Make

```bash
bash scripts/healthcheck.sh
docker compose -f infra/docker-compose.yml --env-file infra/.env config
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
```

## Parar stack

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env down
```

## Regra

Antes de qualquer ação destrutiva, validar impacto em volumes, banco e mídia.
