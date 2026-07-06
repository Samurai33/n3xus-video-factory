---
description: Gera uma especificação agentic para nova feature, módulo, workflow ou projeto N3XUS seguindo o NAF.
allowed-tools: Read Write Edit Bash
---

# Generate Agentic Spec

Use esta skill quando uma nova feature precisar nascer organizada.

## Entrada esperada

- nome da feature;
- objetivo;
- usuários;
- riscos;
- agentes envolvidos;
- skills necessárias;
- infra necessária;
- critérios de pronto.

## Template

```md
# Spec: <nome>

## Objetivo

## Escopo

## Fora de escopo

## Agentes envolvidos

## Skills necessárias

## Arquitetura

## Dados e arquivos

## Segurança

## Operação

## Validação

## Rollback

## Critérios de pronto
```

## Regras

- Não iniciar implementação sem critério de pronto.
- Não criar agente novo se uma skill resolver.
- Não criar serviço novo sem justificar operação e backup.
