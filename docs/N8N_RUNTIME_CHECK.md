# n8n Runtime Check

GitHub stores the project files, but the live n8n runtime must be checked on the machine where Docker is running.

## Check command

```bash
make check-n8n
```

Alternative:

```bash
bash scripts/check-n8n-connection.sh
```

## Healthy result

- `nvf-n8n` container running.
- n8n responding on `http://127.0.0.1:5678`.
- gateway responding on `http://127.0.0.1:8787/health` when enabled.
- Compose status visible.

## Import base workflows

```bash
make import-n8n-workflows
```

This imports the base workflows as inactive workflows for manual review.
