---
description: Valida e sobe a stack Docker Compose da N3xus Video Factory com checagem de configuração, status e logs.
allowed-tools: Read Bash
---

# Deploy Compose Stack

Use esta skill quando o usuário pedir para subir, reiniciar ou validar a stack Docker Compose.

## Pré-check

```bash
test -f infra/docker-compose.yml && echo "compose encontrado" || echo "compose ausente"
test -f infra/.env && echo ".env encontrado" || echo ".env ausente"
docker --version
docker compose version
```

## Validação

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env config
```

## Deploy

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
```

## Pós-check

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
docker compose -f infra/docker-compose.yml --env-file infra/.env logs --tail=80
```

## Rollback

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env down
```

## Regras

- Não prosseguir se `docker compose config` falhar.
- Não expor portas novas sem explicar.
- Não alterar volumes sem alertar risco de perda de dados.
