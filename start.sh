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

docker compose --env-file .env up -d

# Instanznummer merken (falls noch nicht vorhanden)
touch "$INSTANCES_FILE"
if ! grep -qx "$INSTANCE" "$INSTANCES_FILE"; then
  echo "$INSTANCE" >> "$INSTANCES_FILE"
fi

# Warten bis Nextcloud initialisiert ist, dann Proxy-Settings setzen
CONTAINER="${COMPOSE_PROJECT_NAME}-nextcloud-1"
echo "Warte auf Nextcloud-Initialisierung..."
for i in $(seq 1 60); do
  if docker exec "$CONTAINER" test -f /var/www/html/config/config.php 2>/dev/null; then
    echo "config.php gefunden — setze Proxy-Settings..."
    docker exec -u www-data "$CONTAINER" php occ config:system:set trusted_proxies 0 --value="152.53.116.227"
    docker exec -u www-data "$CONTAINER" php occ config:system:set overwriteprotocol --value="https"
    docker exec -u www-data "$CONTAINER" php occ config:system:set overwritehost --value="nextcloud${INSTANCE}.jenslehnhoff.de"
    echo "Proxy-Settings gesetzt."
    break
  fi
  sleep 2
done

echo ""
echo "Instanz ${INSTANCE} gestartet:"
echo "  URL:  https://nextcloud${INSTANCE}.jenslehnhoff.de"
echo "  Name: ${COMPOSE_PROJECT_NAME}"
