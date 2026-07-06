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
- Ops Layer: `infra/`, `scripts/`, `workflows`;
- Control Layer: `gateway/`, `gpt-actions/`, MCP futuro.

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
- N3XUS n8n Control Gateway para Custom GPT Actions;
- OpenAPI schema em `gpt-actions/`;
- acesso administrativo via Tailscale;
- exposição pública somente do gateway, quando necessário, com HTTPS e proxy seguro.

## Padrão de decisão

Antes de implementar, sempre avaliar:

1. custo;
2. privacidade;
3. dependência de SaaS;
4. facilidade de backup;
5. possibilidade de rodar local;
6. manutenção futura;
7. risco de bloqueio por APIs ou automações frágeis;
8. aderência ao NAF;
9. escopo de permissão concedido ao GPT.

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
- GPT nunca deve acessar o n8n diretamente; usar sempre o gateway.
- Workflows criados via GPT devem nascer inativos/draft.
- Ativação, publicação e ações externas exigem revisão humana **em produção** (ver exceção temporária de desenvolvimento abaixo).

## Modo desenvolvimento (temporário — endurecer depois)

Enquanto a stack rodar **apenas localmente** (Windows/Docker Desktop, antes da VM Proxmox `n3xus-video-factory-01` existir), o Claude Code pode agir sem pedir aprovação turno-a-turno para:

- ativar/desativar workflows n8n no ambiente local (`n8n update:workflow --active=...`);
- reimportar, corrigir e limpar workflows n8n locais, incluindo apagar registros comprovadamente duplicados/obsoletos no Postgres local;
- reiniciar containers da stack local para aplicar mudanças de configuração;
- conectar MCPs/tooling local (ex.: Docker MCP Toolkit) usados só para operar essa mesma stack local.

Isso **não muda** nenhuma destas regras, que continuam exigindo revisão humana explícita sempre, em qualquer modo:

- publicação real em redes sociais ou contas oficiais;
- qualquer coisa envolvendo credenciais, tokens, `.env` ou secrets;
- exposição de serviços para fora da rede local/Tailscale;
- qualquer ação fora desta máquina de desenvolvimento (produção, Proxmox, VM remota).

**Gatilho para endurecer:** quando o pipeline local for considerado estável (ver `docs/PROJECT_STATUS.md` → "Definition of done for NAF-2 Operable") ou antes de migrar para a VM Proxmox, remover esta seção inteira e voltar à regra original — revisão humana para toda ativação/publicação/ação externa, inclusive local.

## Comandos principais

```bash
make env-check
make compose-config
make up
make ps
make logs
make health
make backup
make bootstrap-n8n
make bootstrap-gpt-gateway
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
- `/setup-n8n-video-factory`
- `/setup-gpt-n8n-control`
- `/backup-media-store`
- `/create-shorts-batch`
- `/create-growth-experiment`
- `/review-before-publish`
- `/audit-video-pipeline`
- `/generate-agentic-spec`
