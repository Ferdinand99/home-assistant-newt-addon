#!/usr/bin/env bash
set -e

echo "🔹 Starting Newt inside Home Assistant OS..."

CONFIG_PATH="/data/options.json"
HEALTH_FILE="${HEALTH_FILE:-/tmp/healthy}"

export HEALTH_FILE

if [[ ! -f "$CONFIG_PATH" ]]; then
    echo "❌ ERROR: Configuration file not found at $CONFIG_PATH!"
    exit 1
fi

PANGOLIN_ENDPOINT=$(jq -r '.PANGOLIN_ENDPOINT' "$CONFIG_PATH")
NEWT_ID=$(jq -r '.NEWT_ID' "$CONFIG_PATH")
NEWT_SECRET=$(jq -r '.NEWT_SECRET' "$CONFIG_PATH")

# Read custom environment variables
CUSTOM_ENV_VARS=$(jq -r '.custom_env_vars // [] | .[]' "$CONFIG_PATH")

if [[ -z "$PANGOLIN_ENDPOINT" || "$PANGOLIN_ENDPOINT" == "null" || \
      -z "$NEWT_ID" || "$NEWT_ID" == "null" || \
      -z "$NEWT_SECRET" || "$NEWT_SECRET" == "null" ]]; then
    echo "❌ ERROR: Missing required configuration values!"
    exit 1
fi

echo "✅ Configuration Loaded:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"
echo "  HEALTH_FILE=$HEALTH_FILE"

# Export required variables for Newt
export PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT"
export NEWT_ID="$NEWT_ID"
export NEWT_SECRET="$NEWT_SECRET"

# Process and export custom environment variables
if [[ -n "$CUSTOM_ENV_VARS" ]]; then
    echo "✅ Custom Environment Variables:"
    while IFS= read -r env_var; do
        if [[ -n "$env_var" ]]; then
            echo "  $env_var"
            export "$env_var"
        fi
    done <<< "$CUSTOM_ENV_VARS"
fi

# Auto-reconnect loop
while true; do
    echo "🔹 Starting Newt..."

    # Remove stale health file before starting
    rm -f "$HEALTH_FILE"

    /usr/bin/newt

    echo "⚠️ Newt stopped! Waiting 5 seconds before reconnecting..."
    sleep 5
done
