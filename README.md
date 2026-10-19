# Setup

All commands run from the root of this repo on the prod server. TLS and certificates are handled by the edge proxy (`nginx-tcp-proxy`), not here.

```bash
DC="sudo docker compose -f compose.yaml -f prod-overwrite.yaml --env-file .env.prod"
```

## Setup env and secrets

```bash
cp -r secrets.template secrets
cp env.prod.template .env.prod
sudo docker login pixelrent.hu
```

## Setup database

Edit postgres password in `./secrets/postgres_medusajs_pw.txt`

```bash
$DC up postgres -d
```

## Setup medusajs

Edit:

- ADMIN_EMAIL in `./medusa-setup-overwrite.yaml`
- `./secrets/medusajs_admin_pw.txt`

```bash
sudo docker compose -f compose.yaml -f prod-overwrite.yaml -f medusa-setup-overwrite.yaml --env-file .env.prod run --rm medusajs_backend
```

## Run everything

Take a final look at `.env.prod`

```bash
$DC up -d
```

Then enable the `nordstein.conf` site on the edge proxy (it needs the `nordstein-net` network to exist, so start this stack first).

## Setup Pocketbase for analytics

Open `https://<domain>:8090/_/`

Go to `settings` --> `import collection` --> upload `./pocketbase/pb_schema.json`

Go to `system` --> `_superusers` --> `impersonate` --> enter: `1215752191` --> put bearer token in `./secrets/pocketbase_bearer.txt`, then `$DC up -d --force-recreate svelte`

## Update

```bash
git pull
$DC pull && $DC up -d
```
