#!/usr/bin/env bash
set -e  # Stop script on errors

echo "🔹 Starting Newt container using Home Assistant Supervisor API..."

# Check if Supervisor API is available
if ! curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" "http://supervisor/info"; then
    echo "❌ ERROR: Home Assistant Supervisor API is not accessible!"
    exit 22
fi

echo "✅ Supervisor API is available!"

# Set environment variables
PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT:-"https://example.com"}
NEWT_ID=${NEWT_ID:-"default_id"}
NEWT_SECRET=${NEWT_SECRET:-"default_secret"}

echo "🔹 Environment Variables:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Stop and remove any existing Newt container
echo "🔹 Stopping and removing any existing Newt container..."
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "http://supervisor/docker/containers/newt/stop" || echo "❗ Warning: Could not stop container"
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "http://supervisor/docker/containers/newt/remove" || echo "❗ Warning: Could not remove container"

# Create and start a new Newt container using the Supervisor API
echo "🔹 Creating and starting new Newt container via Supervisor API..."
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

# Keep add-on running
exec tail -f /dev/null
