#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

if ! docker compose ps db --status running >/dev/null 2>&1; then
  echo "Service 'db' is not running. Start stack first: docker compose up -d"
  exit 1
fi

docker compose exec -T db psql -U postgres -d postgres < "$ROOT_DIR/scripts/seed_test_data.sql"

echo "Seed completed successfully."