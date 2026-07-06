---
description: Audita o pipeline de vídeos, pastas, assets, scripts, renders, codecs e organização de arquivos.
allowed-tools: Read Bash
---

# Audit Video Pipeline

Use esta skill para revisar se a fábrica de vídeos está organizada e pronta para produção.

## Checagens

```bash
echo "===== MEDIA TREE ====="
find media -maxdepth 3 -type d | sort

echo "===== RAW FILES ====="
find media/raw -maxdepth 2 -type f | sed 's#^./##' | head -100

echo "===== RENDERS ====="
find media/renders -maxdepth 2 -type f | sed 's#^./##' | head -100

echo "===== APPROVED ====="
find media/approved -maxdepth 2 -type f | sed 's#^./##' | head -100
```

## Regras

- Raw nunca deve ser sobrescrito.
- Render deve ter data ou ID.
- Approved deve conter apenas mídia pronta para revisão/publicação.
- Archive deve ser usado para histórico.
