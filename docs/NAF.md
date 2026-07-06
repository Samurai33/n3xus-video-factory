# N3XUS Agentic Framework — NAF

## Definição

O **N3XUS Agentic Framework (NAF)** é o padrão operacional para projetos agentic-first da N3XUS.

Ele define como estruturar:

- memória do projeto;
- agentes especializados;
- skills repetíveis;
- documentação operacional;
- comandos de validação;
- segurança e governança;
- ciclos de melhoria contínua.

## Objetivo

Evitar que cada projeto comece do zero.

Todo novo projeto N3XUS deve nascer com:

```text
CLAUDE.md
AGENTS.md
docs/
.claude/agents/
.claude/skills/
infra/
scripts/
workflows/
```

## Camadas do framework

### 1. Project Memory

Arquivo principal: `CLAUDE.md`.

Guarda regras permanentes, decisões arquiteturais, comandos e comportamento esperado do agente principal.

### 2. Agent Layer

Diretório: `.claude/agents/`.

Cada agente representa uma função especializada:

- arquitetura;
- segurança;
- SRE;
- automação;
- conteúdo;
- análise;
- QA.

### 3. Skill Layer

Diretório: `.claude/skills/`.

Cada skill é um procedimento operacional reutilizável.

Uma skill deve ter:

- objetivo claro;
- quando usar;
- entrada esperada;
- comandos;
- validação;
- rollback quando aplicável.

### 4. Docs Layer

Diretório: `docs/`.

Documenta arquitetura, operação, segurança, roadmap, engine e decisões.

### 5. Ops Layer

Diretórios: `infra/`, `scripts/`, `workflows/`.

Define a execução real:

- Docker Compose;
- comandos locais;
- backups;
- healthchecks;
- workflows n8n;
- workers.

## Padrão de maturidade

### NAF-0 — Ideia

Projeto ainda conceitual.

### NAF-1 — Foundation

Estrutura base, docs, agents e skills iniciais.

### NAF-2 — Operável

Infra sobe localmente com validação.

### NAF-3 — Produção leve

Backups, healthchecks, logs e runbooks.

### NAF-4 — Multi-agent real

Agentes e skills executam ciclos completos.

### NAF-5 — Produto replicável

Framework reutilizável para novos projetos N3XUS.

## Nível atual deste projeto

```text
NAF-1 Foundation
```

Próximo alvo:

```text
NAF-2 Operável
```
