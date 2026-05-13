#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="/home/roob/Developer/Repositories/roobyt"
HEALTH_URL="http://127.0.0.1:8000/health"

cd "$PROJECT_DIR"

echo "==> Updating Tronbyt Docker image..."
sudo docker compose pull

echo "==> Restarting Tronbyt..."
sudo docker compose up -d

echo "==> Current container status:"
sudo docker compose ps

echo "==> Waiting for health check..."
for i in {1..30}; do
  if curl -fsS "$HEALTH_URL" >/dev/null; then
    echo "==> Tronbyt is healthy: $HEALTH_URL"
    exit 0
  fi

  echo "    Not healthy yet, retrying... ($i/30)"
  sleep 2
done

echo "ERROR: Tronbyt did not become healthy."
echo "Recent logs:"
sudo docker compose logs --tail=80 web
exit 1
