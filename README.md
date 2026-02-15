# Nextcloud Demo

Ein einfaches Docker-Setup, um eine lokale Nextcloud-Instanz zu starten.

## Voraussetzungen

- [Docker](https://docs.docker.com/get-docker/) und Docker Compose sind installiert

## Konfiguration

Die Zugangsdaten werden ueber eine `.env`-Datei konfiguriert. Eine Beispieldatei liegt im Repository:

```bash
cp .env.example .env
```

Die Standardwerte koennen in der `.env`-Datei angepasst werden.

## Instanz starten

Jede Instanz bekommt eine Nummer. Der Port ergibt sich automatisch aus `8080 + Nummer`.

```bash
./start.sh 1    # Startet Instanz 1 auf http://localhost:8081
./start.sh 2    # Startet Instanz 2 auf http://localhost:8082
./start.sh 3    # Startet Instanz 3 auf http://localhost:8083
```

Beim ersten Start wird die Datenbank initialisiert und Nextcloud eingerichtet. Das kann ein bis zwei Minuten dauern.

## Instanz stoppen

```bash
./stop.sh 1                 # Instanz 1 stoppen (Daten bleiben erhalten)
./stop.sh 1 --remove-data   # Instanz 1 stoppen und alle Daten loeschen
```

## Zugangsdaten

Die Standard-Zugangsdaten sind in der `.env`-Datei definiert (siehe `.env.example`).

> **Hinweis:** Die mitgelieferten Standardwerte sind nur fuer lokale Entwicklung gedacht. Fuer produktive Umgebungen muessen sichere Passwoerter verwendet werden.

## Komponenten

| Service   | Image             | Port         |
|-----------|-------------------|--------------|
| nextcloud | nextcloud:latest  | 8080 + Nr.   |
| db        | mariadb:11        | -            |

Jede Instanz bekommt eigene Docker Volumes und ein eigenes Netzwerk, sodass die Instanzen vollstaendig voneinander isoliert sind.
