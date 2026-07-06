# N3xus Video Factory

**Fábrica self-hosted de vídeos curtos para HotLead, N3XUS e futuros clientes.**

Este repositório organiza uma infraestrutura agentic-first para criar, cortar, renderizar, revisar e operar vídeos verticais em escala usando uma base gratuita/self-hosted.

## Objetivo

Criar uma máquina de conteúdo com padrão enterprise/minimal/tech, focada em:

- Shorts, Reels, TikTok e LinkedIn videos;
- clipping de vídeos longos;
- geração de variações de hooks, roteiros e CTAs;
- automação com revisão humana;
- infraestrutura local em Proxmox;
- agentes e skills no padrão Claude Code.

## Arquitetura v1

```text
Proxmox
└── VM 360 - n3xus-video-factory-01
    ├── Ubuntu Server 24.04 LTS
    ├── Docker Compose
    ├── n8n
    ├── Postgres
    ├── Redis
    ├── MinIO
    ├── FFmpeg worker
    ├── Video tools/workers
    └── Claude agents + skills
```

## Estrutura

```text
.
├── CLAUDE.md
├── AGENTS.md
├── docs/
├── infra/
├── media/
├── workflows/
├── prompts/
└── .claude/
    ├── agents/
    └── skills/
```

## Stack inicial

- **Docker Compose**: orquestração local simples e auditável.
- **n8n**: workflows de produção, revisão e metadados.
- **Postgres**: persistência de estado.
- **Redis**: fila/cache.
- **MinIO**: storage S3-compatible para assets e renders.
- **FFmpeg worker**: base para renderização/crop/conversão.
- **Tailscale**: acesso administrativo seguro.

## Regras de operação

- Não publicar automaticamente sem revisão humana.
- Não usar cookie/session hack para redes sociais.
- Não commitar `.env`, tokens, chaves ou cookies.
- Não expor painéis sem autenticação.
- Preferir self-hosted e APIs oficiais.
- Toda mudança de infra deve ter validação e rollback.

## Primeiros comandos

```bash
cp infra/.env.example infra/.env
# edite infra/.env com senhas fortes

docker compose -f infra/docker-compose.yml --env-file infra/.env config
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
```

## Acesso local

Por segurança, os serviços iniciais estão bindados em `127.0.0.1`:

- n8n: `http://127.0.0.1:5678`
- MinIO API: `http://127.0.0.1:9000`
- MinIO Console: `http://127.0.0.1:9001`

Para acesso remoto, use Tailscale/SSH tunnel antes de qualquer exposição pública.

## Padrão agentic

Este repo foi preparado para operar com Claude Code:

- `CLAUDE.md`: memória operacional do projeto.
- `.claude/agents/`: especialistas por domínio.
- `.claude/skills/`: procedimentos repetíveis.
- `docs/`: arquitetura, operação, segurança e pipeline.

## Roadmap curto

1. Subir stack base.
2. Validar VM, Docker, volumes e portas.
3. Adicionar workers reais de clipping/Whisper.
4. Criar primeiro lote HotLead.
5. Implementar fluxo n8n de revisão.
6. Conectar storage/backup.

## Status

Base v1 criada para evolução incremental.
