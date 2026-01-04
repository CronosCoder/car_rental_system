#!/usr/bin/env bash
set -e

echo "Starting entrypoint..."

RETRIES=30
until python manage.py migrate --noinput; do
  RETRIES=$((RETRIES-1))
  if [ $RETRIES -le 0 ]; then
    echo "Failed to run migrations after multiple attempts."
    exit 1
  fi
  echo "Database unavailable - sleeping"
  sleep 2
done

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Entrypoint finished, launching process: $@"
exec "$@"
