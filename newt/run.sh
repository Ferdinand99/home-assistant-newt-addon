#!/usr/bin/env bash
source /usr/lib/bashio/bashio.sh

set -e  # Stop script on errors

echo "🔹 Starting Newt container using Home Assistant Supervisor API..."

# Load config from Home Assistant options
PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT:-"https://eample.com"}
NEWT_ID=${NEWT_ID:-"123456789"}
NEWT_SECRET=${NEWT_SECRET:-"waytolongsecret"}


if [[ -z "$PANGOLIN_ENDPOINT" || -z "$NEWT_ID" || -z "$NEWT_SECRET" ]]; then
    echo "❌ ERROR: Missing configuration values!"
    exit 1
fi

echo "✅ Configuration Loaded:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Use Home Assistant Supervisor API to run the Newt container
echo "🔹 Creating and starting Newt container via Supervisor API..."
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "http://supervisor/docker/containers/run" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "newt",
        "image": "fosrl/newt",
        "restart_policy": "unless-stopped",
        "env": [
            "PANGOLIN_ENDPOINT='"$PANGOLIN_ENDPOINT"'",
            "NEWT_ID='"$NEWT_ID"'",
            "NEWT_SECRET='"$NEWT_SECRET"'"
        ]
    }' || { echo "❌ ERROR: Failed to start Newt container via Supervisor API"; exit 22; }

echo "✅ Newt container started successfully!"
exec tail -f /dev/null
