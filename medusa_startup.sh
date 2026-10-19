#!/bin/sh

# i need this "converter" since medusajs reads secrets from ENV and i would have to either:
#   1. modify medusajs files to read /secrets instead
#   2. use this converter script to read secret and write it to ENV

export AUTH_MFA_ENCRYPTION_KEY="$(cat /run/secrets/medusajs_mfa_encryption_key)"
export COOKIE_SECRET="$(cat /run/secrets/medusajs_cookie_secret)"
export JWT_SECRET="$(cat /run/secrets/medusajs_jwt_secret)"
export DATABASE_URL="postgres://medusa_user:$(cat /run/secrets/postgres_medusajs_pw)@postgres:5432/medusa"
echo $DATABASE_URL

# $@ is the CMD from compose/Dockerfile aka it's "npm run start"
exec "$@"
