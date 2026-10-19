#!/bin/sh
set -e

# backup
if [ -f /app/pb_data/data.db ]; then
  cp /app/pb_data/data.db "/app/pb_data/data-$(date +%Y%m%d-%H%M%S).db.bak"
fi

# migrate
pocketbase migrate up --migrationsDir /app/pb_migrations
exec pocketbase serve --dir /app/pb_data --http=0.0.0.0:8090
