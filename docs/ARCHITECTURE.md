# Architecture

## Visão geral

A N3xus Video Factory é uma stack self-hosted para transformar ideias, vídeos longos e assets em vídeos curtos verticais com revisão humana.

```text
User / Team
    ↓
n8n / Dashboard
    ↓
Queue / Metadata
    ↓
Video Workers
    ↓
FFmpeg / Whisper / Captions / Crop / Render
    ↓
Storage
    ↓
Human Review
    ↓
Manual/API official publishing
```

## Infra alvo

- Proxmox
- VM Ubuntu Server 24.04 LTS
- Docker Compose
- Tailscale como acesso administrativo
- Storage local inicialmente, MinIO para compatibilidade S3

## Serviços

### n8n

Orquestra workflows: ideia, roteiro, metadados, geração, revisão e publicação manual.

### Postgres

Armazena estado, workflows e metadados.

### Redis

Fila/cache para workloads futuros.

### MinIO

Storage local compatível com S3 para assets, renders e arquivos aprovados.

### Video worker

Container base com FFmpeg para conversão, validação e render. Deve evoluir para Whisper/clipping/caption workers.

## Rede

Na v1, painéis são bindados em `127.0.0.1`. Acesso remoto deve ser feito por:

1. Tailscale;
2. SSH tunnel;
3. Cloudflare Tunnel/reverse proxy apenas depois de hardening.

## Escalabilidade

A stack começa monolítica em uma VM. Quando necessário:

- separar control plane;
- separar workers;
- mover media para MinIO/NAS;
- usar queue mode no n8n;
- adicionar workers GPU.
