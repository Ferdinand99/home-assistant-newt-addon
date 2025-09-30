#!/usr/bin/env bash
set -e

echo "🔹 Starting Newt inside Home Assistant OS..."

CONFIG_PATH="/data/options.json"

if [[ ! -f "$CONFIG_PATH" ]]; then
    echo "❌ ERROR: Configuration file not found at $CONFIG_PATH!"
    exit 1
fi

PANGOLIN_ENDPOINT=$(jq -r '.PANGOLIN_ENDPOINT' "$CONFIG_PATH")
NEWT_ID=$(jq -r '.NEWT_ID' "$CONFIG_PATH")
NEWT_SECRET=$(jq -r '.NEWT_SECRET' "$CONFIG_PATH")

# Read custom environment variables
CUSTOM_ENV_VARS=$(jq -r '.custom_env_vars // [] | .[]' "$CONFIG_PATH")

if [[ -z "$PANGOLIN_ENDPOINT" || -z "$NEWT_ID" || -z "$NEWT_SECRET" || "$PANGOLIN_ENDPOINT" == "null" ]]; then
    echo "❌ ERROR: Missing required configuration values!"
    exit 1
fi

echo "✅ Configuration Loaded:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Process and display custom environment variables
EXTRA_ENV=""
if [[ -n "$CUSTOM_ENV_VARS" ]]; then
    echo "✅ Custom Environment Variables:"
    while IFS= read -r env_var; do
        if [[ -n "$env_var" ]]; then
            echo "  $env_var"
            # Export the variable for the newt process
            export "$env_var"
            # Also add to the command line (for explicit passing)
            var_name="${env_var%%=*}"
            EXTRA_ENV="$EXTRA_ENV $var_name=\"${!var_name}\""
        fi
    done <<< "$CUSTOM_ENV_VARS"
fi

# 🔁 Auto-reconnect loop
while true; do
    echo "🔹 Starting Newt..."
    # Custom variables are already exported above
    export PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT"
    export NEWT_ID="$NEWT_ID"
    export NEWT_SECRET="$NEWT_SECRET"
    /usr/bin/newt

    echo "⚠️ Newt stopped! Waiting 5 second before reconnecting..."
    sleep 5
done
