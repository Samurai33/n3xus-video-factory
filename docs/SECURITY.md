# Security

## Princípios

- Acesso administrativo via Tailscale.
- Painéis bindados em `127.0.0.1` por padrão.
- Sem credenciais reais no Git.
- Sem cookies/session hacks para plataformas sociais.
- Sem publicação automática sem revisão humana.

## Secrets

Arquivos proibidos no Git:

- `.env`
- `infra/.env`
- tokens
- cookies
- service accounts
- chaves privadas

Use `infra/.env.example` como referência pública.

## Portas iniciais

| Serviço | Porta | Bind |
|---|---:|---|
| n8n | 5678 | 127.0.0.1 |
| MinIO API | 9000 | 127.0.0.1 |
| MinIO Console | 9001 | 127.0.0.1 |

## Checklist antes de exposição pública

- [ ] Autenticação ativa.
- [ ] HTTPS ativo.
- [ ] Logs revisados.
- [ ] Senhas fortes.
- [ ] Backup configurado.
- [ ] Sem portas administrativas abertas na WAN.
- [ ] Sem upload automático frágil.

## Comandos úteis

```bash
ss -lntup
docker compose -f infra/docker-compose.yml --env-file infra/.env ps
grep -R "TOKEN\|PASSWORD\|SECRET\|COOKIE" -n . --exclude-dir=.git
```
