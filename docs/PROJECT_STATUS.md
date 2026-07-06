# Project Status — N3XUS Video Factory

Date: 2026-07-06
Owner: N3XUS / Samurai
Status: Local n8n intake validated

## Executive summary

The project has reached the first operational milestone: the local n8n stack is running and the HotLead intake workflow is responding successfully through the production webhook.

Current state:

```text
PowerShell / MCP / local client
  -> n8n production webhook
  -> Normalize Video Request
  -> Respond Draft Accepted
```

This proves the local control plane is alive, but the system is not yet a complete video factory. The next major milestone is to persist jobs and connect them to review, scripting and rendering stages.

## Validated

- Docker Desktop is available on Windows.
- Docker Compose stack is running locally.
- Services running:
  - n8n
  - Postgres
  - Redis
  - MinIO
  - FFmpeg video-worker
- Base workflows were imported into n8n.
- `NVF 01 - GPT Video Request Intake` was validated through:
  - `/webhook-test/nvf-video-request`
  - `/webhook/nvf-video-request`
- Production webhook returned `200 OK` with the expected draft response.

## Active workflow

```text
Workflow: NVF 01 - GPT Video Request Intake
Purpose: Receive HotLead/video requests and return a draft intake response.
Production endpoint: /webhook/nvf-video-request
Current maturity: Intake validated, no persistence yet.
```

## Imported workflows

```text
NVF 01 - GPT Video Request Intake
NVF 02 - Human Review Gate
NVF 03 - Publish Assist Package
```

`NVF 02` and `NVF 03` are still placeholders. They must be upgraded before being considered operational.

## Main gaps

### P0 — Job persistence

The intake workflow currently responds to the request but does not persist a durable job record.

Required:

- Create a job ID.
- Create normalized job JSON.
- Write job JSON to `/media/scripts` or a dedicated jobs folder.
- Include status fields:
  - `draft`
  - `needs-review`
  - `approved`
  - `rejected`
  - `rendered`
  - `ready-to-publish`
- Include audit fields:
  - createdAt
  - source
  - project
  - pillar
  - targetAudience
  - cta
  - reviewer
  - approval timestamp

### P0 — Human review flow

`NVF 02 - Human Review Gate` is still a manual placeholder.

Required:

- Read pending jobs.
- Present review payload.
- Allow approve/reject/rewrite decisions.
- Prevent rendering or publishing without approval.

### P0 — Safe MCP/GPT control boundary

MCP is being tested locally, but the project policy requires a restricted tool boundary.

Required:

- Rotate any exposed tokens.
- Keep n8n private.
- Expose only safe gateway/MCP capabilities.
- Avoid direct unrestricted admin access to n8n.
- Keep destructive actions disabled.

### P1 — Script generation stage

The project needs the first real content stage after intake.

Required:

- Transform intake into a structured short-video script.
- Generate:
  - hook
  - problem
  - insight
  - proof/example
  - CTA
  - caption
  - hashtags
- Save output as a versioned script artifact.

### P1 — Media job schema

Required:

- Define a canonical job schema.
- Define folders:
  - `/media/scripts`
  - `/media/renders`
  - `/media/approved`
  - `/media/archive`
- Create examples for HotLead.

### P1 — FFmpeg worker handoff

The FFmpeg worker exists but is idle.

Required:

- Define worker contract.
- Create render job input.
- Add a safe command/API boundary for rendering.
- Avoid shell execution from n8n main for production.

### P2 — Observability

Required:

- Health dashboard.
- Execution logs.
- Failed job list.
- Backup validation.
- Basic metrics:
  - jobs received
  - jobs approved
  - renders generated
  - failures

### P2 — Production deployment

The local Windows stack is validated. Production still requires the target VM path.

Required:

- Create Proxmox VM.
- Install Ubuntu Server.
- Move stack to Linux.
- Configure Tailscale-first access.
- Test backup/restore.
- Harden exposed endpoints.

## Next recommended execution order

1. Upgrade workflow 01 to persist job JSON.
2. Create `docs/JOB_SCHEMA.md`.
3. Create sample HotLead job.
4. Upgrade workflow 02 into a real review gate.
5. Create script-generation workflow.
6. Add worker handoff contract.
7. Validate backup and restore.
8. Move from local Windows to Proxmox VM after the local pipeline is stable.

## Definition of done for NAF-2 Operable

The project reaches NAF-2 when:

- A request enters through n8n.
- A durable job file is created.
- A human can approve or reject the job.
- A script package is generated.
- A render handoff is created.
- Logs and backups exist.
- No auto-publishing happens without review.
