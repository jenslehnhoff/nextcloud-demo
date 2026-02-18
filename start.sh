#!/usr/bin/env bash
set -euo pipefail

INSTANCES_FILE="$(dirname "$0")/.instances"

if [ -z "${1:-}" ]; then
  echo "Verwendung: $0 <instanz-nummer>"
  echo "Beispiel:   $0 1"
  exit 1
fi

INSTANCE="$1"
export COMPOSE_PROJECT_NAME="nextcloud-${INSTANCE}"
export NEXTCLOUD_PORT=$((8080 + INSTANCE))
export NEXTCLOUD_HOST="nextcloud${INSTANCE}.jenslehnhoff.de"

docker compose --env-file .env up -d

# Instanznummer merken (falls noch nicht vorhanden)
touch "$INSTANCES_FILE"
if ! grep -qx "$INSTANCE" "$INSTANCES_FILE"; then
  echo "$INSTANCE" >> "$INSTANCES_FILE"
fi

echo ""
echo "Instanz ${INSTANCE} gestartet:"
echo "  URL:  https://nextcloud${INSTANCE}.jenslehnhoff.de"
echo "  Name: ${COMPOSE_PROJECT_NAME}"
