#!/usr/bin/env bash
set -e

echo "Starting Newt container..."

# Load config from Home Assistant options
PANGOLIN_ENDPOINT=$(bashio::config 'PANGOLIN_ENDPOINT')
NEWT_ID=$(bashio::config 'NEWT_ID')
NEWT_SECRET=$(bashio::config 'NEWT_SECRET')

# Ensure Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker is not available inside Home Assistant OS!"
    exit 1
fi

# Stop and remove any existing Newt container
if docker ps -a --format '{{.Names}}' | grep -q "newt"; then
    docker stop newt
    docker rm newt
fi

# Run Newt container
docker run -d --restart unless-stopped \
    --name newt \
    -e PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT" \
    -e NEWT_ID="$NEWT_ID" \
    -e NEWT_SECRET="$NEWT_SECRET" \
    fosrl/newt

echo "Newt container is running!"

# Prevent the script from exiting (Keeps the add-on running)
exec tail -f /dev/null