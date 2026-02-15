#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Verwendung: $0 <instanz-nummer> [--remove-data]"
  echo "Beispiel:   $0 1"
  echo "            $0 1 --remove-data"
  exit 1
fi

INSTANCE="$1"
export COMPOSE_PROJECT_NAME="nextcloud-${INSTANCE}"

if [ "${2:-}" = "--remove-data" ]; then
  docker compose down -v
  echo "Instanz ${INSTANCE} gestoppt und Daten entfernt."
else
  docker compose down
  echo "Instanz ${INSTANCE} gestoppt (Daten bleiben erhalten)."
fi
