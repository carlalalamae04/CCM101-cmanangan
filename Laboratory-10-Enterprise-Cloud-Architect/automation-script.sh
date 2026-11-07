#!/bin/bash
set -euo pipefail
PROJECT_DIR="/home/ccmfinal"
BACKUP_DIR="$PROJECT_DIR/backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/wordpress_${TIMESTAMP}.sql"
TEMP_FILE="${BACKUP_FILE}.tmp"
cd "$PROJECT_DIR"
mkdir -p "$BACKUP_DIR"
if docker compose exec -T db sh -c \
  'exec mysqldump --no-tablespaces -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
  > "$TEMP_FILE"; then
    if [ -s "$TEMP_FILE" ]; then
        mv "$TEMP_FILE" "$BACKUP_FILE"
        echo "Database backup completed: $BACKUP_FILE"
    else
        rm -f "$TEMP_FILE"
        echo "ERROR: The backup file is empty."
        exit 1
    fi
else
    rm -f "$TEMP_FILE"
    echo "ERROR: Database backup command failed."
    exit 1
fi

