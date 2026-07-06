# GPT Actions

This directory contains OpenAPI schemas and instructions for connecting a Custom GPT to the N3XUS Video Factory through a restricted gateway.

## Current schema

```text
n8n-control-gateway.openapi.yaml
```

## Setup summary

1. Deploy the n8n stack.
2. Deploy the GPT gateway.
3. Expose only the gateway through HTTPS.
4. Keep n8n itself private.
5. Paste the OpenAPI schema into the Custom GPT Actions editor.
6. Configure API Key authentication.
7. Test `getGatewayHealth` first.

## Important

Replace this server URL before using the schema:

```text
https://gateway.example.com
```

Use your real HTTPS gateway domain.

## Authentication

Recommended first mode:

```text
Authentication: API Key
Header: Authorization
Value: Bearer <GPT_GATEWAY_API_KEY>
```

## Security model

The GPT never talks directly to n8n.

```text
Custom GPT
  ↓
N3XUS Gateway
  ↓
n8n private API / job files
```
