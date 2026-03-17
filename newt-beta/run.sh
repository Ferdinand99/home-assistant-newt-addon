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
echo "  PANGOLIN_ENDPOINT=[REDACTED]"
echo "  NEWT_ID=[REDACTED]"
echo "  NEWT_SECRET=[REDACTED]"
echo "  HEALTH_FILE=$HEALTH_FILE"

# Export required variables for Newt
export PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT"
export NEWT_ID="$NEWT_ID"
export NEWT_SECRET="$NEWT_SECRET"
export HOME="/data"
export XDG_CONFIG_HOME="/data/.config"

STOP_REQUESTED=0
NEWT_PID=""

handle_shutdown() {
    STOP_REQUESTED=1
    echo "🔹 Shutdown requested, stopping Newt..."
    if [[ -n "$NEWT_PID" ]] && kill -0 "$NEWT_PID" 2>/dev/null; then
        kill "$NEWT_PID" 2>/dev/null || true
        wait "$NEWT_PID" 2>/dev/null || true
    fi
}

trap handle_shutdown SIGTERM SIGINT

# Process and export custom environment variables
if [[ -n "$CUSTOM_ENV_VARS" ]]; then
    echo "✅ Custom Environment Variables:"
    while IFS= read -r env_var; do
        if [[ -n "$env_var" ]]; then
            if [[ ! "$env_var" =~ ^[A-Z_][A-Z0-9_]*=.+$ ]] || [[ "$env_var" == *$'\n'* ]] || [[ "$env_var" == *$'\r'* ]]; then
                echo "⚠️ Skipping invalid custom env var format"
                continue
            fi

            var_name="${env_var%%=*}"
            echo "  ${var_name}=[REDACTED]"
            export "$env_var"
        fi
    done <<< "$CUSTOM_ENV_VARS"
fi

# Auto-reconnect loop
while true; do
    if [[ "$STOP_REQUESTED" -eq 1 ]]; then
        echo "🔹 Exiting reconnect loop"
        exit 0
    fi

    echo "🔹 Starting Newt..."

    # Remove stale health file before starting
    rm -f "$HEALTH_FILE"

    /usr/bin/newt &
    NEWT_PID=$!
    set +e
    wait "$NEWT_PID"
    NEWT_EXIT_CODE=$?
    set -e
    NEWT_PID=""

    if [[ "$STOP_REQUESTED" -eq 1 ]]; then
        echo "🔹 Newt stopped due to shutdown signal"
        exit 0
    fi

    echo "⚠️ Newt stopped with exit code ${NEWT_EXIT_CODE}! Waiting 5 seconds before reconnecting..."
    sleep 5
done
