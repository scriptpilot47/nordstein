#!/bin/sh
set -e

echo "db script running"
export DATABASE_URL="postgres://medusa_user:$(cat /run/secrets/postgres_medusajs_pw)@postgres:5432/medusa"
export JWT_SECRET="$(cat /run/secrets/medusajs_jwt_secret)"
export COOKIE_SECRET="$(cat /run/secrets/medusajs_cookie_secret)"
echo $DATABASE_URL

# create postgres database --> (postgres image already creates it)
# npx medusa db:setup --db medusa

# migrate the database
npx medusa db:migrate

# create admin user
npx medusa user \
  --email "$ADMIN_EMAIL" \
  --password "$(cat /run/secrets/medusajs_admin_pw)"

echo "db created"
