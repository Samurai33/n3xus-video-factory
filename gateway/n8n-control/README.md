# N3XUS n8n Control Gateway

Restricted gateway between a Custom GPT and the N3XUS Video Factory n8n instance.

## Why this exists

A Custom GPT Action needs a public HTTPS API endpoint.

The n8n UI and n8n API should remain private.

This gateway exposes only a small set of safe operations:

- health check;
- create draft video request job;
- list n8n workflows;
- create inactive draft workflow;
- generate safe import command.

## Architecture

```text
Custom GPT Action
  ↓ HTTPS + API Key
N3XUS n8n Control Gateway
  ↓ Docker internal network
n8n API / media job files
```

## Local bootstrap

From the repository root:

```bash
bash scripts/bootstrap-gpt-n8n-gateway.sh
```

Or:

```bash
make bootstrap-gpt-gateway
```

## Local healthcheck

```bash
curl -s http://127.0.0.1:8787/health
```

## Authenticated test

```bash
source infra/.env
curl -s \
  -H "Authorization: Bearer $GPT_GATEWAY_API_KEY" \
  http://127.0.0.1:8787/n8n/workflows
```

## Environment

Required:

```env
GPT_GATEWAY_API_KEY=strong-token
N8N_BASE_URL=http://n8n:5678
N8N_API_KEY=n8n-api-key
```

Optional:

```env
GPT_GATEWAY_PORT=8787
GPT_GATEWAY_REQUIRE_AUTH=true
NVF_JOB_DIR=/media/scripts
```

## Production notes

- Expose only this gateway over HTTPS.
- Keep n8n private.
- Use a strong gateway API key.
- Use a restricted n8n API key if possible.
- Do not expose secrets in logs.
- Mutating actions must remain consequential.
- Workflows created by the gateway are forced inactive.
