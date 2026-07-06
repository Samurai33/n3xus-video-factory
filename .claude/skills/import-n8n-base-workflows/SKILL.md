---
description: Verifica a conexão com n8n/gateway e importa os workflows base da N3XUS Video Factory para o n8n.
allowed-tools: Read Bash
---

# Import n8n Base Workflows

Use esta skill quando o usuário pedir para verificar a conexão com o n8n e criar/importar os workflows base.

## Checar conexão

```bash
make check-n8n
```

Ou:

```bash
bash scripts/check-n8n-connection.sh
```

## Importar workflows base

```bash
make import-n8n-workflows
```

Ou:

```bash
bash scripts/import-n8n-workflows.sh
```

## Workflows esperados

- `NVF 01 - GPT Video Request Intake`
- `NVF 02 - Human Review Gate`
- `NVF 03 - Publish Assist Package`

## Regra

Os workflows devem entrar inativos/draft. Revisar no painel antes de ativar.

## Pós-check

Abrir:

```text
http://127.0.0.1:5678
```

Confirmar que os três workflows aparecem e estão inativos.
