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

## Recently implemented (not yet re-imported/tested in a running n8n)

### P0 — Job persistence (implemented in workflow JSON)

`NVF 01 - GPT Video Request Intake` now has a `Build & Persist Job` Code node that:

- validates `idea` and `targetAudience` are present;
- generates a `jobId` (`{project-slug}-{timestamp}-{random}`);
- builds the full schema-compliant job object from `docs/JOB_SCHEMA.md`;
- writes it to `NVF_JOB_DIR` (default `/media/scripts/{jobId}.json`);
- returns `jobId`, `filePath` and `status` in the webhook response.

This requires `NODE_FUNCTION_ALLOW_BUILTIN=fs,path,crypto` on the n8n container (added to `infra/docker-compose.yml` and `infra/.env.example`). Without it, the Code node's `require('fs')` will throw.

**Still required before this counts as validated:** re-import the workflow (`make import-n8n-workflows` or via n8n UI), restart the `n8n` service so the new env var takes effect, and send a real request through `/webhook/nvf-video-request` to confirm a job file actually lands in `/media/scripts`.

### P0 — Human review flow (implemented in workflow JSON)

`NVF 02 - Human Review Gate` was rewritten from a no-op placeholder into two real webhook endpoints:

- `GET /webhook/nvf-review-pending` — reads every job file in `NVF_JOB_DIR`, filters by `status` in `draft`/`needs-review`, returns a summarized pending list.
- `POST /webhook/nvf-review-decision` — takes `{ jobId, decision, reviewer, notes }`, only accepts `decision` of `approved`/`rejected`, rewrites the job file with the decision, and force-enforces `requiresHumanReview: true` and `autoPublish: false` server-side regardless of the request payload.

**Still a placeholder for the "rewrite" decision path** (only approve/reject exist so far), and there's no UI yet — decisions are raw JSON POSTs. Next natural upgrade is an n8n Form Trigger so a human doesn't need to hand-craft requests.

**Still required before this counts as validated:** re-import the workflow, restart `n8n`, and manually test both endpoints against a job created by NVF 01.

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

1. ~~Upgrade workflow 01 to persist job JSON.~~ Done in workflow JSON — needs re-import + live test.
2. ~~Create `docs/JOB_SCHEMA.md`.~~ Done.
3. ~~Create sample HotLead job.~~ Done.
4. ~~Upgrade workflow 02 into a real review gate.~~ Done in workflow JSON — needs re-import + live test, and still lacks a UI (raw JSON POST only) and a "rewrite" decision path.
5. Re-import both workflows into the running n8n instance and confirm end-to-end: intake → job file on disk → pending list shows it → decision endpoint flips its status.
6. Create script-generation workflow (hook/body/CTA/caption/hashtags from an approved job).
7. Add FFmpeg worker handoff contract (the `video-worker` container is still idle — `sleep infinity` entrypoint).
8. Validate backup and restore.
9. Move from local Windows to Proxmox VM after the local pipeline is stable.

## Open decision needing your sign-off

Enabling `NODE_FUNCTION_ALLOW_BUILTIN=fs,path,crypto` on the n8n container lets any Code node in any workflow read/write the filesystem the container can see (which includes the `../media` mount and, if misused, more of the container's own filesystem). This is standard practice for local self-hosted n8n job-file patterns and n8n itself is only bound to `127.0.0.1`/Tailscale per `docs/SECURITY.md`, so the exposure is local-only for now — but it's a real trust-boundary change worth being aware of before this stack is ever exposed beyond localhost.

## Definition of done for NAF-2 Operable

The project reaches NAF-2 when:

- A request enters through n8n.
- A durable job file is created.
- A human can approve or reject the job.
- A script package is generated.
- A render handoff is created.
- Logs and backups exist.
- No auto-publishing happens without review.
