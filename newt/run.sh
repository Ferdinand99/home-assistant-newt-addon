#!/usr/bin/env bash
set -e  # Stop the script on errors

echo "🔹 Starting Newt inside Home Assistant OS..."

# Load configuration manually from the add-on options JSON file
CONFIG_PATH="/data/options.json"

if [[ ! -f "$CONFIG_PATH" ]]; then
    echo "❌ ERROR: Configuration file not found at $CONFIG_PATH!"
    exit 1
fi

# Extract values from the JSON config
PANGOLIN_ENDPOINT=$(jq -r '.PANGOLIN_ENDPOINT' "$CONFIG_PATH")
NEWT_ID=$(jq -r '.NEWT_ID' "$CONFIG_PATH")
NEWT_SECRET=$(jq -r '.NEWT_SECRET' "$CONFIG_PATH")

# Validate if configuration values are provided
if [[ -z "$PANGOLIN_ENDPOINT" || -z "$NEWT_ID" || -z "$NEWT_SECRET" || "$PANGOLIN_ENDPOINT" == "null" ]]; then
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
