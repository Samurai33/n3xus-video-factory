# MCP n8n Control Plan

## Purpose

This document defines the future MCP path for the N3XUS Video Factory.

The current recommended implementation is **Custom GPT Actions through the N3XUS Gateway**.

MCP comes next, after the gateway policy layer is stable.

## Target architecture

```text
MCP-compatible client
  ↓
N3XUS MCP Server
  ↓
Same policy layer as gateway
  ↓
n8n API / n8n webhooks / job files
```

## Design principle

MCP must not bypass the gateway policy.

The MCP server should expose tools that mirror the same safe operations:

- `get_gateway_health`
- `create_video_request`
- `list_n8n_workflows`
- `create_draft_workflow`
- `generate_n8n_import_command`

## Not allowed

- delete workflows;
- create credentials;
- delete credentials;
- activate workflows automatically;
- run shell commands in n8n main;
- publish automatically;
- mutate secrets.

## Implementation phases

### MCP-0 — Spec only

Current phase.

### MCP-1 — Local MCP server

Create a local MCP server that calls the gateway API.

### MCP-2 — Remote MCP server

Expose MCP server through a secure tunnel or approved remote transport.

### MCP-3 — Production policy

Add audit logs, scoped auth, rate limits and approvals.

## Why this is second

Custom GPT Actions are simpler for the first version because they use an OpenAPI schema and a normal HTTPS endpoint.

MCP is better once we need richer tool discovery, local development ergonomics or multi-client support.
