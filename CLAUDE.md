# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Demo-Projekt: Lokales Nextcloud-Setup mit Docker Compose (Nextcloud + MariaDB).

## Commands

```bash
docker compose up -d       # Starten (Nextcloud auf http://localhost:8080)
docker compose down        # Stoppen
docker compose down -v     # Stoppen und Volumes loeschen
docker compose logs -f     # Logs anzeigen
```

## Architecture

- **compose.yaml** — Docker Compose mit zwei Services:
  - `nextcloud` (nextcloud:latest) — Port 8080
  - `db` (mariadb:11) — internes Netzwerk, nicht exponiert
- Persistente Daten in Docker Volumes: `nextcloud_data`, `db_data`
- DB-Healthcheck stellt sicher, dass Nextcloud erst nach DB-Bereitschaft startet
