# Video Pipeline

## Fluxo de mídia

```text
media/raw
   ↓
media/scripts
   ↓
media/renders
   ↓
media/approved
   ↓
media/archive
```

## Regras

- `raw` nunca deve ser sobrescrito.
- Cada render deve ter data ou ID.
- `approved` deve conter apenas arquivos prontos para revisão/publicação.
- `archive` guarda histórico e versões antigas.

## Padrão de vídeo vertical

- Resolução alvo: 1080x1920.
- Duração inicial: 18 a 32 segundos.
- Hook: 0 a 2 segundos.
- Uma ideia por vídeo.
- CTA único.
- Legenda na tela sempre que possível.

## Pilares HotLead

### Dor comercial

- lead ruim;
- prospecção manual;
- concorrente chegando antes;
- CRM parado;
- falta de previsibilidade.

### Demonstração

- tela real;
- fluxo real;
- antes/depois;
- lead score;
- oportunidade gerada.

### Autoridade

- IA comercial;
- inteligência operacional;
- dado como vantagem competitiva;
- nova geração de prospecção.

## Validação de render

```bash
ffprobe -v error -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 input.mp4
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp4
```
