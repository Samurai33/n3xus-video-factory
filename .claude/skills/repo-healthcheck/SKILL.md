---
description: Valida saúde do repositório, branch, arquivos essenciais, Docker Compose, scripts e estrutura NAF.
allowed-tools: Read Bash
---

# Repo Healthcheck

Use esta skill quando quiser validar se o repositório está íntegro.

## Checagens

```bash
echo "===== GIT ====="
git branch --show-current
git status --short

echo "===== REQUIRED FILES ====="
test -f README.md && echo "OK README.md"
test -f CLAUDE.md && echo "OK CLAUDE.md"
test -f AGENTS.md && echo "OK AGENTS.md"
test -f infra/docker-compose.yml && echo "OK docker-compose"
test -f infra/.env.example && echo "OK .env.example"

echo "===== AGENTS ====="
find .claude/agents -maxdepth 1 -type f | sort

echo "===== SKILLS ====="
find .claude/skills -maxdepth 2 -name SKILL.md | sort

echo "===== SCRIPTS ====="
find scripts -maxdepth 1 -type f | sort
```

## Compose opcional

```bash
if [ -f infra/.env ]; then
  docker compose -f infra/docker-compose.yml --env-file infra/.env config
else
  echo "SKIP compose config: infra/.env ausente"
fi
```

## Resultado esperado

- branch correta;
- arquivos principais presentes;
- agents e skills encontrados;
- compose válido quando `.env` existir.
