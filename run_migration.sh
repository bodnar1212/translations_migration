#!/usr/bin/env bash
set -euo pipefail

HOST="brizy-microservices-xxx-2026-05-07-03-18.cupzc9ey0cip.us-east-1.rds.amazonaws.com"
PORT="3306"
USER="brizy_cloud"
DB="translations"
SQL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/phases"
LOG="/tmp/translations_migration_$(date +%F_%H-%M-%S).log"

PHASES=(
  "01_drop_old_indexes_column.sql"
  "02_add_temp_index.sql"
  "03_build_dup_ids.sql"
  "04_prune_dups.sql"
  "05_rebuild_original_text_indexes.sql"
  "06_build_orphan_otci.sql"
  "07_prune_orphans.sql"
  "08_fk_and_final_index_changes.sql"
)

if [[ ! -d "$SQL_DIR" ]]; then
  echo "ERROR: phases directory not found: $SQL_DIR"
  exit 1
fi

echo "Migration started at $(date)" | tee -a "$LOG"
echo "Host: $HOST" | tee -a "$LOG"
echo "Database: $DB" | tee -a "$LOG"
echo "SQL_DIR: $SQL_DIR" | tee -a "$LOG"
echo "Log: $LOG" | tee -a "$LOG"

for f in "${PHASES[@]}"; do
  if [[ ! -f "$SQL_DIR/$f" ]]; then
    echo "ERROR: missing phase file: $SQL_DIR/$f" | tee -a "$LOG"
    exit 1
  fi

  echo "===== RUNNING: $f =====" | tee -a "$LOG"
  mysql -h "$HOST" -P "$PORT" -u "$USER" -p "$DB" \
    --connect-timeout=30 --show-warnings --verbose --table --comments \
    < "$SQL_DIR/$f" | stdbuf -oL tee -a "$LOG"
  echo "===== DONE: $f =====" | tee -a "$LOG"
done

echo "Migration finished at $(date)" | tee -a "$LOG"
echo "Log: $LOG"
