#!/usr/bin/env bash
set -euo pipefail

INSTANCES_FILE="$(dirname "$0")/.instances"

stop_instance() {
  local instance="$1"
  local remove_data="$2"

  export COMPOSE_PROJECT_NAME="nextcloud-${instance}"

  if [ "$remove_data" = true ]; then
    docker compose down -v
    echo "Instanz ${instance} gestoppt und Daten entfernt."
  else
    docker compose down
    echo "Instanz ${instance} gestoppt (Daten bleiben erhalten)."
  fi

  # Instanznummer aus der Liste entfernen
  if [ -f "$INSTANCES_FILE" ]; then
    grep -vx "$instance" "$INSTANCES_FILE" > "${INSTANCES_FILE}.tmp" || true
    mv "${INSTANCES_FILE}.tmp" "$INSTANCES_FILE"
  fi
}

# --all: Alle bekannten Instanzen stoppen
if [ "${1:-}" = "--all" ]; then
  if [ ! -f "$INSTANCES_FILE" ] || [ ! -s "$INSTANCES_FILE" ]; then
    echo "Keine laufenden Instanzen bekannt."
    exit 0
  fi

  REMOVE_DATA=false
  if [ "${2:-}" = "--remove-data" ]; then
    REMOVE_DATA=true
  fi

  echo "Stoppe alle Instanzen..."
  while read -r instance; do
    stop_instance "$instance" "$REMOVE_DATA"
  done < "$INSTANCES_FILE"
  echo ""
  echo "Alle Instanzen gestoppt."
  exit 0
fi

# Einzelne Instanz stoppen
if [ -z "${1:-}" ]; then
  echo "Verwendung: $0 <instanz-nummer> [--remove-data]"
  echo "          $0 --all [--remove-data]"
  exit 1
fi

REMOVE_DATA=false
if [ "${2:-}" = "--remove-data" ]; then
  REMOVE_DATA=true
fi

stop_instance "$1" "$REMOVE_DATA"
