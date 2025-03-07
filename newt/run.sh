#!/usr/bin/env bash
set -e

echo "Starting Newt container..."

# Load config from environment variables
PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT:-"https://example.com"}
NEWT_ID=${NEWT_ID:-"default_id"}
NEWT_SECRET=${NEWT_SECRET:-"default_secret"}

# Check if Docker is available
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

# Keep the script running
exec tail -f /dev/null