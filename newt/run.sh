#!/usr/bin/env bash
set -e  # Stop the script on errors

echo "🔹 Starting Newt inside Home Assistant OS..."

# Load configuration from environment variables set by Home Assistant
export PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT}
export NEWT_ID=${NEWT_ID}
export NEWT_SECRET=${NEWT_SECRET}

# Validate if configuration values are provided
if [[ -z "$PANGOLIN_ENDPOINT" || -z "$NEWT_ID" || -z "$NEWT_SECRET" ]]; then
    echo "❌ ERROR: Missing required configuration values!"
    exit 1
fi

echo "✅ Configuration Loaded:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Run Newt inside the add-on container using environment variables
echo "🔹 Running Newt..."
PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT" NEWT_ID="$NEWT_ID" NEWT_SECRET="$NEWT_SECRET" /usr/bin/newt &

echo "✅ Newt is running!"
exec tail -f /dev/null  # Keep the add-on running
