# n8n Video Factory Setup

This document defines the n8n baseline for the N3XUS Video Factory.

## Goal

Use n8n as the **control plane** for the Video Factory:

- receive campaign/video requests;
- create structured jobs;
- route jobs to review;
- write metadata files;
- trigger external workers later;
- keep human approval before publishing.

n8n should **not** be responsible for heavy video rendering inside the main process. Rendering, Whisper, FFmpeg-heavy work and future GPU tasks should run in dedicated workers.

## Official patterns used

The baseline follows these official n8n patterns:

- Docker self-hosting.
- PostgreSQL instead of SQLite for durable workflows, credentials and executions.
- Persistent `/home/node/.n8n` volume.
- Task runners enabled.
- File-based binary data for the single-node v1.
- Redis present for future queue mode.
- Human review gates before publishing.
- CLI import of inactive workflows for review before activation.

## Recommended project mode

### V1 — Single-main, safe local mode

Use this now.

```text
n8n main
├── UI/API/Webhooks
├── Postgres
├── Redis ready for future queue mode
├── MinIO ready for future object storage
└── mounted project folders
```

### V2 — Queue mode with workers

Use this later, after the v1 stack is stable.

```text
n8n main
├── Redis queue
├── Postgres
├── n8n worker 01
├── n8n worker 02
└── external media workers
```

Important: n8n queue mode does not support binary data storage in filesystem for persistent binary workflows. If the project moves to queue mode with binary assets flowing through n8n, use S3-compatible storage.

## Real n8n examples that map to this project

### 1. Local File Trigger pattern

Use case for this repo:

```text
media/raw receives a new file
  ↓
n8n detects the file
  ↓
create metadata job
  ↓
route to review/render workflow
```

Relevant n8n node: **Local File Trigger**.

Why it matters:

- good for local self-hosted pipelines;
- detects files or folders being added, changed or deleted;
- useful for `media/raw` ingestion.

Security note: this node is self-hosted only and can be risky with untrusted users. Keep n8n private and do not allow random users to edit workflows.

### 2. Read/Write Files from Disk pattern

Use case for this repo:

```text
workflow receives video idea
  ↓
create JSON metadata
  ↓
write job file into workflows/jobs or media/scripts
```

Relevant n8n node: **Read/Write Files from Disk**.

Why it matters:

- lets n8n write structured job specs;
- allows handoff from n8n to external workers;
- avoids running shell commands in n8n.

### 3. Webhook Intake pattern

Use case for this repo:

```text
POST /webhook/video-request
  ↓
validate payload
  ↓
create campaign/video job
  ↓
wait for human review
```

Relevant n8n node: **Webhook**.

Why it matters:

- can act like a lightweight internal API;
- supports test and production URLs;
- supports authentication methods;
- can receive binary data if configured.

### 4. Human Review Gate pattern

Use case for this repo:

```text
generated script/render package
  ↓
Wait node pauses execution
  ↓
reviewer approves/rejects
  ↓
workflow continues or archives the job
```

Relevant n8n node: **Wait**.

Why it matters:

- allows human-in-the-loop review;
- can resume on webhook call or form submission;
- stores execution state in the database while paused.

### 5. Execute Command pattern — restricted

Use case for this repo:

Only use in a controlled, isolated environment. Prefer external workers for FFmpeg and shell tasks.

Relevant n8n node: **Execute Command**.

Why it matters:

- can call local commands in self-hosted n8n;
- useful for prototypes;
- risky if workflow editors are untrusted;
- disabled by default in n8n 2.0 due to security considerations.

N3XUS rule:

```text
Do not use Execute Command for production rendering in the n8n main container.
Use a dedicated video-worker/API instead.
```

## Base workflow blueprints

### Workflow A — Video Request Intake

Purpose:
Receive a video idea from a form or webhook and create a structured job.

Recommended nodes:

```text
Webhook or Form Trigger
  → Edit Fields / Set
  → Validate required fields
  → Write Files from Disk
  → Wait for review
```

Payload example:

```json
{
  "project": "HotLead",
  "pillar": "Pain / Demo / Authority",
  "idea": "Your competitor is reaching leads before you",
  "targetAudience": "B2B founders and sales teams",
  "cta": "Comment HOTLEAD",
  "priority": "normal"
}
```

Generated file example:

```text
media/scripts/hotlead-YYYYMMDD-HHMMSS.json
```

### Workflow B — Raw Video Ingest

Purpose:
Watch `media/raw` and create a processing job when a new source video is added.

Recommended nodes:

```text
Local File Trigger
  → Read/Write Files from Disk
  → Extract metadata later
  → Create render job
  → Wait for review
```

### Workflow C — Review Board

Purpose:
Human approves/rejects scripts and renders before publishing.

Recommended nodes:

```text
Manual Trigger or Webhook
  → Read job metadata
  → Wait for form submitted / webhook call
  → IF approved
      → move to approved
    ELSE
      → move to archive / needs-fix
```

### Workflow D — Publish Assist

Purpose:
Generate publishing package, not auto-post.

Recommended output:

```text
Title
Description
Caption
Hashtags
Thumbnail notes
Publishing checklist
Platform-specific adjustments
```

N3XUS rule:

```text
Publishing is manual or official-API-only after human approval.
```

## One-command setup

From the repository root on the target Linux VM:

```bash
bash scripts/bootstrap-n8n-video-factory.sh
```

Or with Make:

```bash
make bootstrap-n8n
```

What it does:

1. verifies Docker and Docker Compose;
2. creates `infra/.env` if missing;
3. generates local secrets;
4. creates required folders;
5. validates Docker Compose;
6. starts the stack;
7. runs healthcheck;
8. prints local access URLs.

## Check connection

Run:

```bash
make check-n8n
```

Or:

```bash
bash scripts/check-n8n-connection.sh
```

This checks:

- local files;
- Docker containers;
- n8n local HTTP response;
- GPT gateway health;
- Compose status.

## Import base workflows

Run:

```bash
make import-n8n-workflows
```

Or:

```bash
bash scripts/import-n8n-workflows.sh
```

The import command uses:

```bash
docker exec nvf-n8n n8n import:workflow --separate --input=/workflows/importable
```

The n8n CLI deactivates imported workflows by default unless `--activeState=fromJson` is used. We intentionally keep workflows inactive for review before activation.

## Base workflows created by this repo

See:

```text
docs/N8N_CREATED_WORKFLOWS.md
```

Expected workflows after import:

```text
NVF 01 - GPT Video Request Intake
NVF 02 - Human Review Gate
NVF 03 - Publish Assist Package
```

## Manual setup

```bash
cp infra/.env.example infra/.env
nano infra/.env
make compose-config
make up
make ps
make health
```

Without Make:

```bash
docker compose -f infra/docker-compose.yml --env-file infra/.env config
docker compose -f infra/docker-compose.yml --env-file infra/.env up -d
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
bash scripts/healthcheck.sh
```

## Access

Default local bindings:

| Service | URL |
|---|---|
| n8n | `http://127.0.0.1:5678` |
| MinIO API | `http://127.0.0.1:9000` |
| MinIO Console | `http://127.0.0.1:9001` |

For remote access, use Tailscale or SSH tunnel first.

## Suggested SSH tunnel

From your workstation:

```bash
ssh -L 5678:127.0.0.1:5678 samurai@<vm-ip-or-tailscale-name>
```

Then open:

```text
http://127.0.0.1:5678
```

## First workflow to create manually in n8n

The import command already creates three base workflows. If you want to create the first one manually instead, start with this:

### HotLead Video Request Intake

Nodes:

```text
Manual Trigger
  → Edit Fields
  → Write Files from Disk
  → Wait
```

Edit Fields values:

```json
{
  "project": "HotLead",
  "type": "short-video",
  "pillar": "Pain",
  "idea": "You do not need more leads; you need better signals",
  "cta": "Comment HOTLEAD",
  "status": "draft"
}
```

Write path:

```text
/media/scripts/hotlead-test-job.json
```

Validation:

```bash
cat media/scripts/hotlead-test-job.json
```

## Production rules

- Keep n8n private.
- Keep editing access restricted.
- Do not enable public panels before hardening.
- Do not use cookie/session automation for social platforms.
- Do not auto-publish without review.
- Do not run heavy rendering inside the n8n main container.
- Use external workers for FFmpeg, Whisper and GPU workloads.

## Next implementation steps

1. Run `make check-n8n`.
2. Run `make import-n8n-workflows`.
3. Review imported workflows in the UI.
4. Activate only the intake workflow after review.
5. Add Wait/Form review gate.
6. Create a job file schema in `docs/JOB_SCHEMA.md`.
7. Add a small worker API for render jobs.
8. Add MinIO/S3 storage for approved renders.
9. Add analytics capture after manual publishing.
