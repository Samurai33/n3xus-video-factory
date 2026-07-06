---
description: Inicializa a estrutura base do projeto N3xus Video Factory com diretórios, documentos, infra e padrões operacionais.
allowed-tools: Read Write Edit Bash
---

# Bootstrap N3xus Video Factory

Use esta skill quando o usuário pedir para iniciar, organizar ou recriar a estrutura base do projeto.

## Objetivo

Criar a estrutura mínima de produção:

- docs/
- infra/
- media/
- workflows/
- prompts/
- .claude/agents/
- .claude/skills/

## Procedimento

1. Verifique a pasta atual:

```bash
pwd
ls -la
```

2. Crie diretórios base:

```bash
mkdir -p docs infra/{nginx,n8n,postgres,redis,minio,workers} media/{raw,scripts,renders,approved,archive} workflows prompts/{hooks,scripts,captions,ctas} .claude/{agents,skills}
```

3. Crie `.gitignore` com:

- `.env`
- `media/raw/`
- `media/renders/`
- `media/archive/`
- arquivos temporários
- secrets

4. Crie `.env.example`.

5. Gere um README inicial.

6. Finalize com validação:

```bash
find . -maxdepth 3 -type d | sort
```

## Resultado esperado

Estrutura pronta para receber Docker Compose, agentes, skills e documentação.
