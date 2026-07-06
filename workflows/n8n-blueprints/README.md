# n8n Workflow Blueprints

These are implementation blueprints for the N3XUS Video Factory.

They are intentionally conservative: n8n controls the workflow, while heavy media processing should run in external workers.

## Blueprint 01 — Video Request Intake

Purpose:
Receive an idea/campaign request and create a structured job file.

Nodes:

```text
Webhook or Manual Trigger
  → Edit Fields
  → IF required fields are valid
  → Read/Write Files from Disk
  → Wait for approval
```

Output path:

```text
/media/scripts/<project>-<timestamp>.json
```

Use for:

- HotLead content requests;
- N3XUS Dev posts;
- client campaign ideas;
- script generation queue.

## Blueprint 02 — Raw Video Ingest

Purpose:
Detect files added to `media/raw` and create processing jobs.

Nodes:

```text
Local File Trigger
  → Read/Write Files from Disk
  → Edit Fields
  → Write job metadata
  → Wait for review
```

Use for:

- long video intake;
- screen recordings;
- product demo captures;
- future clipping pipeline.

## Blueprint 03 — Human Review Gate

Purpose:
Pause workflow execution until a reviewer approves/rejects.

Nodes:

```text
Manual Trigger or Webhook
  → Read job metadata
  → Wait
  → IF approved
      → mark approved
    ELSE
      → mark needs-fix
```

Use for:

- script approval;
- render approval;
- publishing package approval.

## Blueprint 04 — Publish Assist

Purpose:
Generate publishing metadata without auto-posting.

Nodes:

```text
Manual Trigger
  → Read approved job
  → Generate title/description/caption manually or through approved LLM node
  → Write publishing package
  → Wait for final review
```

Output:

```text
Title
Description
Caption
Hashtags
CTA
Platform notes
Checklist
```

## Blueprint 05 — Worker Handoff

Purpose:
Let n8n create jobs that a dedicated worker can process later.

Nodes:

```text
Webhook / Local File Trigger
  → Edit Fields
  → Write job JSON to disk
  → optional HTTP Request to worker API later
  → Wait for result
```

Rule:

```text
n8n creates and supervises jobs. Workers do heavy rendering.
```

## Security rules

- Keep workflows private.
- Restrict editor access.
- Do not use browser cookies for publishing.
- Do not auto-publish without human approval.
- Avoid Execute Command in production n8n main.
- Do not process untrusted files without validation.
