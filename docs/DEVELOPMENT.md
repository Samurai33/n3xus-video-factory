# Development

## Padrão de trabalho

Este repositório deve evoluir por ciclos pequenos:

1. planejar;
2. implementar;
3. validar;
4. documentar;
5. revisar segurança;
6. criar próximo incremento.

## Branch principal

```text
main
```

## Convenção de commits

Use Conventional Commits:

```text
feat: adiciona nova capacidade
fix: corrige problema
chore: manutenção
infra: alteração de infraestrutura
docs: documentação
ops: operação, scripts e runbooks
security: segurança
```

## Regras de qualidade

- Toda mudança de infra precisa passar em `docker compose config`.
- Toda skill precisa ter validação.
- Todo script precisa ser seguro para rodar mais de uma vez quando possível.
- Todo arquivo sensível deve ficar fora do Git.
- Toda automação de publicação deve ter revisão humana.

## Checklist de PR/commit

- [ ] Não há secrets.
- [ ] Docs atualizados.
- [ ] Comandos de validação existem.
- [ ] Risco operacional documentado.
- [ ] Rollback definido quando necessário.
