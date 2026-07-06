---
description: Revisa um vídeo, roteiro ou pacote de publicação antes de sair para Shorts/Reels/TikTok/LinkedIn.
allowed-tools: Read Bash
---

# Review Before Publish

Use esta skill antes de publicar qualquer vídeo.

## Checklist

- [ ] Hook aparece nos primeiros 2 segundos.
- [ ] Uma ideia por vídeo.
- [ ] Promessa não é enganosa.
- [ ] CTA único.
- [ ] Legendas legíveis.
- [ ] Áudio compreensível.
- [ ] Sem música/footage sem direito claro.
- [ ] Sem dados sensíveis.
- [ ] Sem automação de upload não oficial.
- [ ] Arquivo está em `media/approved`.

## Validação técnica

```bash
ffprobe -v error -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 <arquivo>
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 <arquivo>
```

## Decisão

Retorne:

- aprovado;
- aprovado com ajustes;
- reprovado.

Inclua motivo e ação recomendada.
