---
description: Executa backup seguro de documentação, workflows, prompts e mídia curada da N3xus Video Factory.
allowed-tools: Read Bash
---

# Backup Media Store

Use esta skill antes de alterações grandes ou antes de mover mídia aprovada.

## Comando principal

```bash
bash scripts/backup.sh
```

## Validação

```bash
ls -lah backups | tail
find backups -maxdepth 2 -type f | tail -20
```

## Regras

- Não copiar `.env` para Git.
- Guardar secrets separadamente.
- Validar restore antes de considerar backup confiável.
- Não sobrescrever mídia raw.
