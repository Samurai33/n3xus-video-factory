# GPT-connected n8n Control Layer

## Goal

Create a safe control layer so a Custom GPT can operate parts of the N3XUS Video Factory through **Actions** or, later, **MCP**.

The rule is:

```text
Custom GPT / MCP Client
  ↓
N3XUS Gateway
  ↓
n8n API / n8n Webhooks / job files
  ↓
Human review gates
  ↓
Workers
```

Do **not** connect a GPT directly to the full n8n admin API with unrestricted permissions.

## Why a gateway is required

A gateway gives us:

- limited endpoints;
- rate limits;
- audit logs;
- explicit policy checks;
- active=false workflow imports by default;
- human approval before destructive or external actions;
- a single public HTTPS endpoint for GPT Actions;
- a private internal connection to n8n.

## Official constraints to respect

GPT Actions use an OpenAPI schema. ChatGPT uses operation names, descriptions and parameters to decide which action to call, so schema names must be clear and restrictive.

GPT Actions support authentication modes including None, API Key and OAuth. For this project, start with API Key for a private owner-operated GPT, then move to OAuth if multiple users need individual permissions.

Production GPT Actions require HTTPS/TLS on port 443 with a valid public certificate. Requests also have action-specific limits and timeouts, so long-running rendering must not happen inside an Action request.

n8n has a public REST API that can perform many of the same tasks as the GUI. n8n also recommends its CLI for command-line automation, CI/CD and AI agent integrations.

## Recommended phases

### Phase 3A — Custom GPT Actions through Gateway

Use this first.

```text
Custom GPT Action
  ↓ HTTPS + API Key
N3XUS n8n Control Gateway
  ↓ private network
n8n API / n8n webhooks
```

Allowed actions:

- check gateway health;
- list n8n workflows;
- create a video request job;
- create/import draft workflows with `active=false`;
- generate CLI commands for manual import;
- request activation, but not auto-activate without approval.

### Phase 3B — MCP Server

Use this later when the gateway has stable tools.

```text
MCP client / compatible ChatGPT integration
  ↓
N3XUS MCP Server
  ↓
Same policy layer
  ↓
n8n API / jobs
```

The MCP server should expose the same safe capabilities as the gateway, not broader access.

## Security policy

### Allowed by GPT

- Create draft video jobs.
- Create draft workflow JSON.
- List workflows.
- Read basic status.
- Generate import commands.
- Request activation for human approval.

### Not allowed by GPT directly

- Delete workflows.
- Delete credentials.
- Create credentials.
- Disable auth.
- Run shell commands in n8n main.
- Activate workflows automatically.
- Publish to social platforms automatically.
- Modify secrets.

## Network model

### Local only during development

```text
Custom GPT cannot call this directly unless exposed over public HTTPS.
Use this for local testing only.
```

### Production-ready access

```text
ChatGPT Action
  ↓ public HTTPS 443
Cloudflare Tunnel / reverse proxy
  ↓
Gateway container
  ↓ internal Docker network
n8n container
```

The n8n UI should remain private. Expose only the gateway.

## Custom GPT instructions

Use these instructions in the Custom GPT builder:

```text
You are the N3XUS Video Factory Operator.

You operate through a restricted gateway, not directly against n8n.

Rules:
- Never request activation of a workflow unless the user explicitly asks.
- Never ask to publish automatically to social platforms.
- Use createVideoRequest for content jobs.
- Use listN8nWorkflows before proposing workflow changes.
- Use createDraftWorkflow only for inactive draft workflows.
- Keep all workflows human-reviewed.
- Treat every mutation as consequential.
- Summarize what changed after every action.
```

## GPT Action authentication

Recommended first setup:

```text
Authentication type: API Key
Header: Authorization
Value format: Bearer <GPT_GATEWAY_API_KEY>
```

Later setup:

```text
Authentication type: OAuth
Use when multiple users need scoped access.
```

## OpenAPI schema

Use:

```text
gpt-actions/n8n-control-gateway.openapi.yaml
```

Before pasting into the GPT builder, replace:

```text
https://gateway.example.com
```

with your real gateway URL.

## One-command local gateway setup

After the gateway files are present and Docker is installed:

```bash
bash scripts/bootstrap-gpt-n8n-gateway.sh
```

Or:

```bash
make bootstrap-gpt-gateway
```

## Testing locally

```bash
curl -s http://127.0.0.1:8787/health | jq
```

With API key:

```bash
curl -s \
  -H "Authorization: Bearer $GPT_GATEWAY_API_KEY" \
  http://127.0.0.1:8787/n8n/workflows | jq
```

## Production checklist

- [ ] Gateway has HTTPS/TLS public endpoint.
- [ ] n8n UI remains private.
- [ ] Gateway API key is strong.
- [ ] n8n API key is not exposed to GPT directly.
- [ ] Rate limiting is enabled at proxy or gateway.
- [ ] Mutating endpoints are marked consequential in OpenAPI.
- [ ] Workflow imports force `active=false`.
- [ ] Human approval is required for activation and publishing.
- [ ] Logs do not leak secrets.

## Decision

Start with **Custom GPT Actions + Gateway**.

MCP is a second layer after the safe Action gateway is working.
