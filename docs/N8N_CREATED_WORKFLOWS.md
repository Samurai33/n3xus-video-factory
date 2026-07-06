# n8n Created Workflows

This document lists the base workflows that should exist in n8n after running the import command.

## Connection check

Run:

```bash
make check-n8n
```

Or:

```bash
bash scripts/check-n8n-connection.sh
```

This checks:

- local repo files;
- Docker containers;
- n8n local HTTP response;
- GPT gateway health;
- Compose status.

## Import command

Run:

```bash
make import-n8n-workflows
```

Or:

```bash
bash scripts/import-n8n-workflows.sh
```

The import uses:

```bash
docker exec nvf-n8n n8n import:workflow --separate --input=/workflows/importable
```

n8n imports workflows as inactive by default unless `--activeState=fromJson` is used. This project intentionally keeps imported workflows inactive for human review.

## Imported workflows

### 1. NVF 01 - GPT Video Request Intake

File:

```text
workflows/importable/01-gpt-video-request-intake.json
```

Purpose:

- receive a POST webhook;
- normalize a video request;
- return a draft accepted response;
- never render or publish.

Webhook path:

```text
/nvf-video-request
```

Expected payload:

```json
{
  "project": "HotLead",
  "pillar": "Pain",
  "idea": "You do not need more leads; you need better signals",
  "targetAudience": "B2B founders and sales teams",
  "cta": "Comment HOTLEAD"
}
```

### 2. NVF 02 - Human Review Gate

File:

```text
workflows/importable/02-human-review-gate.json
```

Purpose:

- create a manual review checkpoint;
- mark the decision as pending;
- serve as the base for future Wait/Form approval flow.

### 3. NVF 03 - Publish Assist Package

File:

```text
workflows/importable/03-publish-assist-package.json
```

Purpose:

- create a safe publishing package;
- generate title/caption/hashtags/checklist baseline;
- enforce manual or official-API-only publishing;
- never auto-publish.

## Recommended validation after import

Open n8n:

```text
http://127.0.0.1:5678
```

Confirm these workflows exist and remain inactive:

```text
NVF 01 - GPT Video Request Intake
NVF 02 - Human Review Gate
NVF 03 - Publish Assist Package
```

Only activate a workflow after reviewing every node and confirming there are no unintended external actions.

## Next workflow improvements

- Add file writing to `/media/scripts` once the Write Files node is validated in your n8n version.
- Replace placeholders with Wait/Form review nodes.
- Connect publish package to approved render metadata.
- Add worker handoff through the GPT gateway or worker API.
