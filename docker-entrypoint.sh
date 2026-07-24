#!/usr/bin/env sh
set -e

# Detect if Drizzle Kit is installed and configured
if grep -q '"drizzle-kit"' package.json 2>/dev/null && ls drizzle.config.* >/dev/null 2>&1; then
  echo "Drizzle Kit and configuration detected, syncing database..."
  # Check if migrations directory exists and has SQL files
  if [ -d "drizzle" ] && ls drizzle/*.sql >/dev/null 2>&1; then
    echo "Migrations detected, running 'yarn drizzle-kit migrate'..."
    yarn drizzle-kit migrate || echo "Warning: drizzle-kit migrate failed. Proceeding anyway..."
  else
    echo "No migrations found, running 'yarn drizzle-kit push'..."
    yarn drizzle-kit push || echo "Warning: drizzle-kit push failed. Proceeding anyway..."
  fi
fi

if [ "$*" = "" ]; then
  if [ -f /opt/project/dist/server/entry.mjs ]; then
    exec node /opt/project/dist/server/entry.mjs
  else
    exec /docker-entrypoint.sh nginx -g "daemon off;"
  fi
else
  exec "$@"
fi