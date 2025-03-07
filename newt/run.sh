#!/usr/bin/env bash
set -e  # Stop script on errors

echo "🔹 Starting Newt container using Home Assistant Supervisor API..."

# Ensure the Supervisor API is accessible
if ! curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" "http://supervisor/info"; then
    echo "❌ ERROR: Home Assistant Supervisor API is not accessible!"
    exit 22
fi
echo "✅ Supervisor API is available!"

# Retrieve and display add-on environment variables
PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT:-"https://example.com"}
NEWT_ID=${NEWT_ID:-"default_id"}
NEWT_SECRET=${NEWT_SECRET:-"default_secret"}

echo "🔹 Environment Variables:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Send the environment variables to Home Assistant
echo "🔹 Setting environment variables for the add-on..."
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "http://supervisor/addons/self/options" \
    -H "Content-Type: application/json" \
    -d '{
        "options": {
            "PANGOLIN_ENDPOINT": "'"$PANGOLIN_ENDPOINT"'",
            "NEWT_ID": "'"$NEWT_ID"'",
            "NEWT_SECRET": "'"$NEWT_SECRET"'"
        }
    }' || { echo "❌ ERROR: Failed to set environment variables"; exit 22; }

# Start the add-on
echo "🔹 Starting the add-on..."
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "http://supervisor/addons/self/start" || { echo "❌ ERROR: Failed to start add-on"; exit 22; }

echo "✅ Newt add-on started successfully!"
exec tail -f /dev/null  # Keep the add-on running
