# Commands

Comandos operacionais do projeto.

## Git

```bash
git fetch origin
git checkout main
git pull origin main
git status
```

## Bootstrap local

```bash
cp infra/.env.example infra/.env
nano infra/.env
```

## Compose

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env config
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
docker compose -f infra/docker-compose.yml --env-file infra/.env logs --tail=120
docker compose -f infra/docker-compose.yml --env-file infra/.env down
```

## Healthcheck

```bash
bash scripts/healthcheck.sh
```

## Backup

```bash
bash scripts/backup.sh
```

## Inspeção de portas

```bash
ss -lntup || true
```

## Diagnóstico Docker

```bash
docker ps -a
docker volume ls
docker network ls
docker system df
```

## Validação de vídeo

```bash
ffprobe -v error -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 input.mp4
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp4
```
