#!/usr/bin/env sh
set -e

if [[ "$*" == *"crond"* ]]; then
  echo "Installing crontab..."
  # Check for scheduled jobs
  if ls src/jobs/*.ts >/dev/null 2>&1; then
    > /tmp/crontab_jobs
    for job_file in src/jobs/*.ts; do
      echo "* * * * * cd $(pwd) && yarn tsx $job_file > /proc/\$(cat /var/run/crond.pid)/fd/1 2>&1" | tee -a /tmp/crontab_jobs
    done
    crontab /tmp/crontab_jobs
    rm /tmp/crontab_jobs
  fi

  echo "Wait for 10 seconds..."
  # Wait for db sync from base container
  sleep 10
else
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
fi

if [ "$*" = "" ]; then
  if [ -f dist/server/entry.mjs ]; then
    exec node dist/server/entry.mjs
  else
    exec /docker-entrypoint.sh nginx -g "daemon off;"
  fi
else
  exec "$@"
fi