#!/usr/bin/env bash
set -e

echo "Starter Newt container..."

# Hent verdier fra Home Assistant config
PANGOLIN_ENDPOINT=$(bashio::config 'PANGOLIN_ENDPOINT')
NEWT_ID=$(bashio::config 'NEWT_ID')
NEWT_SECRET=$(bashio::config 'NEWT_SECRET')

# Sjekk at Docker kjører
if ! docker info >/dev/null 2>&1; then
    echo "Docker er ikke tilgjengelig i Home Assistant OS!"
    exit 1
fi

# Stopp og fjern gammel container hvis den finnes
if docker ps -a --format '{{.Names}}' | grep -q "newt"; then
    docker stop newt
    docker rm newt
fi

# Kjør Newt-containeren
docker run -d --restart unless-stopped \
    --name newt \
    -e PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT" \
    -e NEWT_ID="$NEWT_ID" \
    -e NEWT_SECRET="$NEWT_SECRET" \
    fosrl/newt

echo "Newt-container kjører!"
exec tail -f /dev/null
