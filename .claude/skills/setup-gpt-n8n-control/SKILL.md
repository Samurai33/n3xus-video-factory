---
description: Configura e valida a conexão Custom GPT Actions ou MCP futuro para operar o n8n através do gateway seguro da N3XUS.
allowed-tools: Read Bash
---

# Setup GPT n8n Control

Use esta skill para configurar a Fase 3: GPT conectado ao n8n.

## Arquitetura

```text
Custom GPT
  → GPT Actions OpenAPI
  → N3XUS n8n Control Gateway
  → n8n API / job files
```

## Comando único local

```bash
bash scripts/bootstrap-gpt-n8n-gateway.sh
```

Ou:

```bash
make bootstrap-gpt-gateway
```

## Validação local

```bash
curl -s http://127.0.0.1:8787/health
```

## Validação autenticada

```bash
source infra/.env
curl -s \
  -H "Authorization: Bearer $GPT_GATEWAY_API_KEY" \
  http://127.0.0.1:8787/n8n/workflows
```

## OpenAPI para Custom GPT

Use:

```text
gpt-actions/n8n-control-gateway.openapi.yaml
```

Troque:

```text
https://gateway.example.com
```

pelo domínio HTTPS real do gateway.

## Regras

- Não expor n8n diretamente.
- Não dar API key admin irrestrita ao GPT.
- Não autoativar workflows.
- Não publicar sem revisão humana.
- Não executar shell no n8n main.
- Usar gateway para impor política.
