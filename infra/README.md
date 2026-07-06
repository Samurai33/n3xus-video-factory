# Infra

Infraestrutura Docker Compose da N3xus Video Factory.

## Serviços iniciais

- Postgres
- Redis
- MinIO
- n8n
- FFmpeg worker

## Uso

```bash
cp infra/.env.example infra/.env
docker compose -f infra/docker-compose.yml --env-file infra/.env config
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
```

## Segurança

As portas públicas estão bindadas em `127.0.0.1` por padrão. Não altere para `0.0.0.0` sem revisão de segurança.
