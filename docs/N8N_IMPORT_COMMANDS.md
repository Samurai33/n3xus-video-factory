# n8n Import Commands

## Check runtime

```bash
make check-n8n
```

Alternative:

```bash
bash scripts/check-n8n-connection.sh
```

## Import base workflows

```bash
make import-n8n-workflows
```

Alternative:

```bash
bash scripts/import-n8n-workflows.sh
```

## Workflows imported

- `NVF 01 - GPT Video Request Intake`
- `NVF 02 - Human Review Gate`
- `NVF 03 - Publish Assist Package`

## Safety

The import uses the n8n CLI default behavior, keeping imported workflows inactive unless explicitly configured otherwise.
