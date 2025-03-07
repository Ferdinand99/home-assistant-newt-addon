#!/usr/bin/env bash
set -e  # Stop script on errors

echo "🔹 Starting Newt container using Home Assistant Supervisor API..."

# Load config from Home Assistant options
PANGOLIN_ENDPOINT=$(bashio::config 'PANGOLIN_ENDPOINT')
NEWT_ID=$(bashio::config 'NEWT_ID')
NEWT_SECRET=$(bashio::config 'NEWT_SECRET')

if [[ -z "$PANGOLIN_ENDPOINT" || -z "$NEWT_ID" || -z "$NEWT_SECRET" ]]; then
    echo "❌ ERROR: Missing configuration values!"
    exit 1
fi

echo "✅ Configuration Loaded:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Run Newt container
docker run -d --restart unless-stopped \
    --name newt \
    -e PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT" \
    -e NEWT_ID="$NEWT_ID" \
    -e NEWT_SECRET="$NEWT_SECRET" \
    fosrl/newt

echo "✅ Newt container started successfully!"
exec tail -f /dev/null
