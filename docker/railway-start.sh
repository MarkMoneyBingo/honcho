#!/bin/bash
# Marlet Railway start: migrations, then deriver + API in one container.
# Single container (instead of compose's api+deriver pair) because the
# LanceDB vector store is embedded local storage on the Railway volume and
# must be shared by the deriver (writer) and the API (dialectic reader).
# If either process exits, the container exits and Railway restarts it.
set -e

python scripts/provision_db.py

python -m src.deriver &
fastapi run --host 0.0.0.0 --port "${PORT:-8000}" src/main.py &

wait -n
echo "[railway-start] a process exited; terminating container" >&2
exit 1
