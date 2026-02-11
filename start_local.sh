#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [ -d .venv ]; then
  # shellcheck disable=SC1091
  source .venv/bin/activate
fi

export FLASK_APP=faislook_app.main:app
export DATABASE_URL="${DATABASE_URL:-sqlite:///faislook.db}"
export FLASK_RUN_HOST=0.0.0.0
export FLASK_RUN_PORT="${PORT:-5000}"

exec flask run
