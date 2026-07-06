# Importable n8n Workflows

This folder contains the base workflows to import into the N3XUS Video Factory n8n instance.

## Import

From the repository root on the n8n host:

```bash
make import-n8n-workflows
```

Or:

```bash
bash scripts/import-n8n-workflows.sh
```

## Workflows

| File | Workflow | Purpose |
|---|---|---|
| `01-gpt-video-request-intake.json` | `NVF 01 - GPT Video Request Intake` | Accepts a draft video request webhook and returns a safe draft response. |
| `02-human-review-gate.json` | `NVF 02 - Human Review Gate` | Base review checkpoint for scripts/renders before activation or publication. |
| `03-publish-assist-package.json` | `NVF 03 - Publish Assist Package` | Creates a safe publishing package without auto-publishing. |

## Safety

n8n imports workflows inactive by default. Keep them inactive until reviewed in the UI.
