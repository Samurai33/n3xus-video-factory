# Job Schema — N3XUS Video Factory

This document defines the first stable job contract for the N3XUS Video Factory.

The job schema is the handoff between:

```text
n8n intake
  -> human review
  -> script generation
  -> render worker
  -> publish assist package
```

## File location

Initial local mode:

```text
/media/scripts/{project}-{jobId}.json
```

Recommended repository example location:

```text
workflows/examples/hotlead-job.example.json
```

## Status lifecycle

```text
draft
  -> needs-review
  -> approved
  -> scripted
  -> render-ready
  -> rendered
  -> ready-to-publish
  -> published-manual
```

Rejection path:

```text
needs-review
  -> rejected
  -> archived
```

## Required fields

```json
{
  "schemaVersion": "1.0.0",
  "jobId": "hotlead-20260706-0001",
  "project": "HotLead",
  "type": "short-video",
  "pillar": "Pain",
  "idea": "Empreendedores perdem vendas porque tratam todos os leads iguais",
  "targetAudience": "empreendedores digitais",
  "cta": "Comenta HOTLEAD",
  "status": "needs-review",
  "requiresHumanReview": true,
  "autoPublish": false,
  "createdAt": "2026-07-06T05:30:00.000Z",
  "updatedAt": "2026-07-06T05:30:00.000Z",
  "source": {
    "system": "n8n",
    "workflow": "NVF 01 - GPT Video Request Intake",
    "endpoint": "/webhook/nvf-video-request"
  },
  "review": {
    "decision": "pending",
    "reviewer": null,
    "reviewedAt": null,
    "notes": null
  },
  "script": {
    "hook": null,
    "body": null,
    "cta": null,
    "caption": null,
    "hashtags": []
  },
  "render": {
    "status": "not-started",
    "format": "vertical-9x16",
    "durationTargetSeconds": 30,
    "outputPath": null
  },
  "publish": {
    "status": "not-ready",
    "manualOnly": true,
    "platforms": [],
    "publishedAt": null
  }
}
```

## Safety rules

- `requiresHumanReview` must remain `true` for every generated job.
- `autoPublish` must remain `false` until a production publishing policy exists.
- n8n must not perform heavy rendering in the main container.
- Shell execution from n8n main should be avoided for production.
- Credentials and tokens must never be stored in job files.

## Minimal valid HotLead intake

Input accepted by `NVF 01`:

```json
{
  "project": "HotLead",
  "pillar": "Pain",
  "idea": "Empreendedores perdem vendas porque tratam todos os leads iguais",
  "targetAudience": "empreendedores digitais",
  "cta": "Comenta HOTLEAD"
}
```

## Next implementation step

Upgrade `NVF 01 - GPT Video Request Intake` so that after normalization it writes a job JSON file before returning the response.
