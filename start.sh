#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Verwendung: $0 <instanz-nummer>"
  echo "Beispiel:   $0 1"
  exit 1
fi

INSTANCE="$1"
export COMPOSE_PROJECT_NAME="nextcloud-${INSTANCE}"
export NEXTCLOUD_PORT=$((8080 + INSTANCE))

docker compose --env-file .env up -d

echo ""
echo "Instanz ${INSTANCE} gestartet:"
echo "  URL:  http://localhost:${NEXTCLOUD_PORT}"
echo "  Name: ${COMPOSE_PROJECT_NAME}"
