# Operations

## Pré-requisitos

- Ubuntu Server 24.04 LTS
- Docker
- Docker Compose plugin
- usuário operacional sem root direto
- Tailscale para acesso remoto

## Bootstrap

```bash
cp infra/.env.example infra/.env
nano infra/.env
```

Use senhas fortes em:

- `POSTGRES_PASSWORD`
- `MINIO_ROOT_PASSWORD`
- `N8N_ENCRYPTION_KEY`

## Validar Compose

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env config
```

## Subir stack

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
```

## Status

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
docker compose -f infra/docker-compose.yml --env-file infra/.env logs --tail=120
```

## Parar stack

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env down
```

## Diagnóstico da VM

```bash
hostnamectl
uptime
free -h
df -h
ss -lntup
docker ps -a
```

## Backup inicial

Na v1, priorizar:

- volumes Docker;
- `media/approved`;
- `media/scripts`;
- workflows exportados do n8n;
- `.env` fora do Git, guardado em local seguro.

Todo backup precisa de teste de restore antes de ser considerado válido.
