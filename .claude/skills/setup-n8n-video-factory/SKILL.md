---
description: Configura a base n8n da N3XUS Video Factory com bootstrap único, validação, acesso local e primeiro workflow seguro.
allowed-tools: Read Bash
---

# Setup n8n Video Factory

Use esta skill quando for configurar ou validar a camada n8n do projeto.

## Comando único

```bash
bash scripts/bootstrap-n8n-video-factory.sh
```

Ou:

```bash
make bootstrap-n8n
```

## Validação

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
bash scripts/healthcheck.sh
```

## Acesso

```text
http://127.0.0.1:5678
```

Para acesso remoto, use túnel SSH ou Tailscale.

## Primeiro workflow seguro

Criar manualmente no n8n:

```text
Manual Trigger
  → Edit Fields
  → Write Files from Disk
  → Wait
```

Objetivo:

- receber ideia de vídeo;
- gerar JSON de job em `/media/scripts`;
- pausar para revisão humana.

## Regras

- Não publicar automaticamente.
- Não usar cookies/session hacks.
- Não rodar render pesado dentro do n8n main.
- Não usar Execute Command em produção sem isolamento.
