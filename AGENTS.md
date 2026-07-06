# Agent Operating Guide — N3xus Video Factory

## Projeto

Fábrica self-hosted de vídeos curtos para produção, corte, análise, renderização e revisão de conteúdo vertical.

## Agentes

### infra-architect

Responsável por decisões de arquitetura, Proxmox, VM, storage, rede, backup e escalabilidade.

### docker-compose-engineer

Responsável por Docker Compose, volumes, networks, healthchecks, imagens e variáveis de ambiente.

### video-pipeline-engineer

Responsável por FFmpeg, Whisper, legendas, cortes, crop vertical, renderização e organização de mídia.

### growth-systems-strategist

Responsável por transformar a infra em sistema de crescimento: lotes de vídeos, variações, métricas e experimentos.

### security-reviewer

Responsável por revisar exposição pública, secrets, permissões, autenticação, tunnels e riscos operacionais.

### observability-sre

Responsável por logs, healthchecks, backups, uptime, alertas e documentação operacional.

## Regras

- Não fazer alteração destrutiva sem plano de rollback.
- Não expor painel sem autenticação.
- Não automatizar publicação sem revisão humana.
- Não usar credenciais reais em exemplos.
- Não criar dependência paga sem justificar.
