# N3xus Video Factory — Claude Project Memory

## Missão

Este projeto cria uma fábrica self-hosted de vídeos curtos para HotLead, N3XUS e futuros clientes, com foco em:

- produção de Shorts/Reels/TikTok em escala;
- automação controlada;
- qualidade premium;
- segurança operacional;
- infraestrutura gratuita ou self-hosted sempre que possível;
- criação do padrão N3XUS Agentic Framework para futuros projetos.

## NAF — N3XUS Agentic Framework

O NAF é o padrão operacional agentic-first da N3XUS.

Camadas:

- Project Memory: `CLAUDE.md`;
- Agent Layer: `.claude/agents/`;
- Skill Layer: `.claude/skills/`;
- Docs Layer: `docs/`;
- Ops Layer: `infra/`, `scripts/`, `workflows/`.

Nível atual:

```text
NAF-1 Foundation
```

Próximo alvo:

```text
NAF-2 Operável
```

## Arquitetura alvo

A stack principal roda em Proxmox, dentro de uma VM Ubuntu Server 24.04 LTS chamada `n3xus-video-factory-01`.

Componentes principais:

- Docker Compose como orquestração inicial;
- n8n para workflows;
- Postgres para estado e metadados;
- Redis para fila/cache;
- MinIO ou storage local para vídeos e assets;
- workers de vídeo para FFmpeg, Whisper, clipping, captions e render;
- Makefile/Taskfile para operação local;
- scripts de healthcheck e backup;
- acesso administrativo via Tailscale;
- exposição pública somente quando necessário e com proxy seguro.

## Padrão de decisão

Antes de implementar, sempre avaliar:

1. custo;
2. privacidade;
3. dependência de SaaS;
4. facilidade de backup;
5. possibilidade de rodar local;
6. manutenção futura;
7. risco de bloqueio por APIs ou automações frágeis;
8. aderência ao NAF.

## Regras obrigatórias

- Nunca publicar automaticamente em contas oficiais sem revisão humana.
- Nunca usar cookies/session hacks para upload em plataformas sociais.
- Preferir APIs oficiais ou fluxo manual de aprovação.
- Não commitar `.env`, chaves, tokens, cookies ou credenciais.
- Toda mudança de infra precisa ter rollback claro.
- Toda skill operacional deve incluir validação.
- Todo Compose deve usar volumes nomeados ou paths explícitos.
- Todo serviço exposto deve ter justificativa.
- Tailscale é o acesso administrativo padrão.
- Cloudflare Tunnel ou reverse proxy só depois de validação local.
- Não criar agente novo quando uma skill resolver.
- Não criar serviço novo sem plano de operação e backup.

## Comandos principais

```bash
make env-check
make compose-config
make up
make ps
make logs
make health
make backup
```

Sem Make:

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env config
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
docker compose -f infra/docker-compose.yml --env-file infra/.env logs --tail=120
docker compose -f infra/docker-compose.yml --env-file infra/.env down
```

## Padrão de resposta esperado

Quando trabalhar neste projeto:

- pensar como arquiteto sênior;
- entregar comandos copiáveis;
- validar antes de aplicar;
- explicar riscos;
- manter o padrão self-hosted;
- separar pesquisa, plano, implementação e validação;
- evoluir o projeto por incrementos versionáveis.

## Estrutura agentic

Use subagents quando a tarefa exigir análise especializada:

- `chief-operator` para coordenação e prioridade;
- `infra-architect` para arquitetura;
- `docker-compose-engineer` para Compose e containers;
- `video-pipeline-engineer` para FFmpeg, Whisper, captions e render;
- `growth-systems-strategist` para viral loops e experimentos;
- `workflow-automation-engineer` para n8n e automações;
- `prompt-systems-engineer` para prompts, hooks e templates;
- `content-safety-editor` para claims, copyright e risco de publicação;
- `data-analytics-engineer` para métricas e experimentos;
- `security-reviewer` para exposição, secrets e permissões;
- `observability-sre` para logs, métricas, saúde e backups;
- `qa-reviewer` para qualidade e validação.

Use skills quando a tarefa for procedimento repetível:

- `/bootstrap-video-factory`
- `/deploy-compose-stack`
- `/validate-infra`
- `/repo-healthcheck`
- `/run-local-ops`
- `/backup-media-store`
- `/create-shorts-batch`
- `/create-growth-experiment`
- `/review-before-publish`
- `/audit-video-pipeline`
- `/generate-agentic-spec`
