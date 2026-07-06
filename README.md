<div align="center">

# N3XUS Video Factory

**Self-hosted agentic video factory for Shorts, Reels, TikTok and growth experiments.**

A production-oriented foundation for turning ideas, long-form content and product demos into short-form video assets with automation, human review, observability and reusable agentic workflows.

[![Validate Compose](https://github.com/Samurai33/n3xus-video-factory/actions/workflows/validate-compose.yml/badge.svg?branch=main)](https://github.com/Samurai33/n3xus-video-factory/actions/workflows/validate-compose.yml)
[![Last Commit](https://img.shields.io/github/last-commit/Samurai33/n3xus-video-factory/main?style=flat-square&logo=github)](https://github.com/Samurai33/n3xus-video-factory/commits/main)
[![Repo Size](https://img.shields.io/github/repo-size/Samurai33/n3xus-video-factory?style=flat-square&logo=github)](https://github.com/Samurai33/n3xus-video-factory)
[![Top Language](https://img.shields.io/github/languages/top/Samurai33/n3xus-video-factory?style=flat-square)](https://github.com/Samurai33/n3xus-video-factory)
[![Docker Compose](https://img.shields.io/badge/orchestration-Docker%20Compose-2496ED?style=flat-square&logo=docker&logoColor=white)](infra/docker-compose.yml)
[![NAF](https://img.shields.io/badge/NAF-1%20Foundation-7C3AED?style=flat-square)](docs/NAF.md)
[![Security](https://img.shields.io/badge/security-human%20review%20required-111827?style=flat-square)](docs/SECURITY.md)

</div>

---

## Table of Contents

- [Overview](#overview)
- [Why this exists](#why-this-exists)
- [Architecture](#architecture)
- [N3XUS Agentic Framework](#n3xus-agentic-framework)
- [Tech Stack](#tech-stack)
- [Repository Structure](#repository-structure)
- [Quickstart](#quickstart)
- [Operations](#operations)
- [Agentic System](#agentic-system)
- [Security Model](#security-model)
- [Roadmap](#roadmap)
- [Documentation](#documentation)
- [Current Status](#current-status)

---

## Overview

**N3XUS Video Factory** is a self-hosted foundation for building a short-form video production pipeline with automation, review gates and growth experimentation.

It is designed for:

- product demo clips;
- short-form content production;
- long-form-to-short-form clipping;
- hook, script and CTA variation testing;
- human-reviewed publishing workflows;
- future integration with analytics and lead generation systems.

This repository is also the first implementation of the **N3XUS Agentic Framework (NAF)**: a reusable project structure for N3XUS initiatives using `CLAUDE.md`, specialized agents, skills, operational docs and safe infrastructure patterns.

---

## Why this exists

Modern short-form video workflows usually fail in one of two ways:

1. They are too manual, slow and inconsistent.
2. They are too automated, generic and unsafe for serious brands.

This project aims for the middle path:

```text
automation speed + human judgment + self-hosted control + repeatable experimentation
```

The goal is not to blindly auto-post content. The goal is to create a controlled production system where ideas, scripts, cuts, renders, reviews and publishing packages can move through a repeatable pipeline.

---

## Architecture

Target deployment for v1:

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
    ├── Video tooling / future workers
    ├── Healthcheck and backup scripts
    └── Claude agents + skills
```

Logical pipeline:

```text
Input
  ↓
Research Engine
  ↓
Idea Engine
  ↓
Script Engine
  ↓
Storyboard Engine
  ↓
Video Engine
  ↓
Review Engine
  ↓
Publish Assist Engine
  ↓
Analytics Engine
```

More details: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) and [`docs/ENGINE.md`](docs/ENGINE.md).

---

## N3XUS Agentic Framework

The **N3XUS Agentic Framework (NAF)** defines how N3XUS projects should be structured and operated.

```text
Project Memory  -> CLAUDE.md
Agent Layer     -> .claude/agents/
Skill Layer     -> .claude/skills/
Docs Layer      -> docs/
Ops Layer       -> infra/ + scripts/ + workflows/
```

Current maturity:

```text
NAF-1 Foundation
```

Next target:

```text
NAF-2 Operable
```

See: [`docs/NAF.md`](docs/NAF.md).

---

## Tech Stack

| Layer | Tooling | Purpose |
|---|---|---|
| Orchestration | Docker Compose | Local/self-hosted service orchestration |
| Workflow automation | n8n | Reviewable automation and pipelines |
| Database | Postgres | Durable state and metadata |
| Queue/cache | Redis | Job coordination and future queue mode |
| Object storage | MinIO | S3-compatible local media storage |
| Media processing | FFmpeg worker | Render, convert, inspect and process video |
| Ops | Makefile / Taskfile | Repeatable local commands |
| Access model | Tailscale-first | Private administrative access |
| Agentic layer | Claude agents + skills | Reusable project intelligence |

---

## Repository Structure

```text
.
├── .claude/
│   ├── agents/                  # Specialized Claude agents
│   └── skills/                  # Reusable operational skills
├── .github/workflows/           # CI validation workflows
├── backups/                     # Local backup output placeholder
├── docs/                        # Architecture, operations, security and NAF docs
├── infra/                       # Docker Compose and infrastructure files
├── media/                       # Raw, scripted, rendered and approved media paths
├── prompts/                     # Hooks, scripts, captions and CTA prompt libraries
├── scripts/                     # Healthcheck and backup scripts
├── workflows/                   # n8n workflow placeholders
├── AGENTS.md                    # Human-readable agent guide
├── CLAUDE.md                    # Project memory for Claude Code
├── Makefile                     # Make-based operations
├── Taskfile.yml                 # Task-based operations
└── README.md
```

---

## Quickstart

### 1. Clone

```bash
git clone https://github.com/Samurai33/n3xus-video-factory.git
cd n3xus-video-factory
```

### 2. Create local environment

```bash
cp infra/.env.example infra/.env
```

Edit `infra/.env` and replace placeholder values with strong local secrets.

Required values:

```env
POSTGRES_PASSWORD=change-me-strong-password
MINIO_ROOT_PASSWORD=change-me-strong-password
N8N_ENCRYPTION_KEY=change-me-32-plus-chars-random
```

### 3. Validate Compose

```bash
make compose-config
```

Without Make:

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env config
```

### 4. Start the stack

```bash
make up
make ps
```

Without Make:

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
```

---

## Operations

Common commands:

```bash
make help
make env-check
make compose-config
make up
make ps
make logs
make health
make backup
```

Direct script execution:

```bash
bash scripts/healthcheck.sh
bash scripts/backup.sh
```

Default local service bindings:

| Service | URL |
|---|---|
| n8n | `http://127.0.0.1:5678` |
| MinIO API | `http://127.0.0.1:9000` |
| MinIO Console | `http://127.0.0.1:9001` |

Services are intentionally bound to `127.0.0.1` for the initial security posture. Use Tailscale or SSH tunneling for remote administration before considering public exposure.

---

## Agentic System

This repository includes specialized agents for infrastructure, video processing, content systems, operations and security.

Examples:

- `chief-operator`
- `infra-architect`
- `docker-compose-engineer`
- `video-pipeline-engineer`
- `workflow-automation-engineer`
- `growth-systems-strategist`
- `prompt-systems-engineer`
- `content-safety-editor`
- `data-analytics-engineer`
- `security-reviewer`
- `observability-sre`
- `qa-reviewer`

Skills include repeatable procedures such as:

- `/repo-healthcheck`
- `/run-local-ops`
- `/deploy-compose-stack`
- `/backup-media-store`
- `/create-shorts-batch`
- `/create-growth-experiment`
- `/review-before-publish`
- `/audit-video-pipeline`
- `/generate-agentic-spec`

The project memory lives in [`CLAUDE.md`](CLAUDE.md). The agent guide lives in [`AGENTS.md`](AGENTS.md).

---

## Security Model

This project is built around a conservative operating model:

- no automatic publishing to official accounts without human review;
- no cookie/session hacks for social platforms;
- no secrets committed to Git;
- no public panel exposure by default;
- local-first and Tailscale-first administration;
- official APIs or manual approval flows preferred;
- generated media and backups are excluded from Git.

See: [`docs/SECURITY.md`](docs/SECURITY.md).

---

## Roadmap

### Foundation

- [x] Repository created
- [x] Default branch set to `main`
- [x] Claude project memory added
- [x] Agents and skills initialized
- [x] Docker Compose baseline added
- [x] NAF documentation added
- [x] Healthcheck and backup scripts added

### NAF-2 Operable

- [ ] Validate stack on the target VM
- [ ] Confirm n8n + Postgres + Redis + MinIO startup
- [ ] Add real video worker profile
- [ ] Add Whisper/transcription workflow
- [ ] Add render validation workflow
- [ ] Add first HotLead content experiment

### NAF-3 Production Lite

- [ ] Backup restore test
- [ ] Log and metrics runbook
- [ ] Hardening checklist
- [ ] Tailscale-only admin guide
- [ ] Review board workflow
- [ ] Analytics feedback loop

---

## Documentation

| Document | Purpose |
|---|---|
| [`docs/NAF.md`](docs/NAF.md) | N3XUS Agentic Framework |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Infrastructure and system architecture |
| [`docs/ENGINE.md`](docs/ENGINE.md) | Video Factory engine design |
| [`docs/OPERATIONS.md`](docs/OPERATIONS.md) | Operational commands and procedures |
| [`docs/SECURITY.md`](docs/SECURITY.md) | Security posture and constraints |
| [`docs/VIDEO_PIPELINE.md`](docs/VIDEO_PIPELINE.md) | Media processing rules and flow |
| [`docs/ROADMAP.md`](docs/ROADMAP.md) | Project roadmap |
| [`docs/COMMANDS.md`](docs/COMMANDS.md) | Command reference |
| [`docs/DEVELOPMENT.md`](docs/DEVELOPMENT.md) | Development workflow |

---

## Current Status

```text
Status: Active foundation
Branch: main
Maturity: NAF-1 Foundation
Next milestone: NAF-2 Operable
Primary deployment target: Proxmox VM / Ubuntu Server 24.04 LTS
```

This is an early-stage foundation. It is not yet a complete video automation product, but the repository is structured to evolve into one through safe, versioned, agentic increments.
