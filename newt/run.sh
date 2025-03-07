#!/usr/bin/env bash
source /usr/lib/bashio/bashio.sh

set -e  # Stop script on errors

echo "🔹 Starting Newt container using Home Assistant Supervisor API..."

# Load config from Home Assistant options
PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT:-"https://dash.opland.net"}
NEWT_ID=${NEWT_ID:-"ru32vsg8ls5lx93"}
NEWT_SECRET=${NEWT_SECRET:-"5rbqgpc292989uk9kz52hmypoyz6u9jf7k670fqja8p4un8o"}


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
