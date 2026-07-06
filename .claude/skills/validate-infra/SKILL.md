---
description: Faz diagnóstico da VM, Docker, disco, memória, portas, containers e saúde geral da infraestrutura.
allowed-tools: Read Bash
---

# Validate Infra

Use esta skill para validar a saúde da VM e da stack.

## Sistema

```bash
echo "===== HOST ====="
hostnamectl || true

echo "===== UPTIME ====="
uptime

echo "===== DISK ====="
df -h

echo "===== MEMORY ====="
free -h

echo "===== CPU ====="
nproc
```

## Docker

```bash
echo "===== DOCKER ====="
docker --version
docker compose version
docker ps -a
```

## Portas

```bash
echo "===== PORTAS ====="
ss -lntup || true
```

## Compose

```bash
echo "===== COMPOSE CONFIG ====="
docker compose -f infra/docker-compose.yml --env-file infra/.env config

echo "===== COMPOSE PS ====="
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
```

## Resultado esperado

Retorne:

- serviços ativos;
- serviços com falha;
- risco de disco;
- risco de memória;
- portas expostas;
- próximos comandos recomendados.
