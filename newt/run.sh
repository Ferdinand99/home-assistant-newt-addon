#!/usr/bin/env bash
set -e  # Stop the script on errors

echo "🔹 Starting Newt container using Home Assistant Supervisor API..."
echo "🔹 Checking Docker availability..."

if ! docker info >/dev/null 2>&1; then
    echo "❌ ERROR: Docker is NOT available inside Home Assistant OS!"
    exit 22
fi

echo "✅ Docker is available!"

echo "🔹 Checking environment variables..."
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Stop and remove any existing Newt container
echo "🔹 Stopping and removing any existing Newt container..."
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "http://supervisor/docker/containers/newt/stop" || echo "❗ Warning: Could not stop container"
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "http://supervisor/docker/containers/newt/remove" || echo "❗ Warning: Could not remove container"

# Start a new Newt container
echo "🔹 Starting new Newt container..."
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "http://supervisor/docker/containers/create" \
    -H "Content-Type: application/json" \
    -d '{
        "Image": "fosrl/newt",
        "HostConfig": {
            "RestartPolicy": {"Name": "unless-stopped"},
            "Env": [
                "PANGOLIN_ENDPOINT='"$PANGOLIN_ENDPOINT"'",
                "NEWT_ID='"$NEWT_ID"'",
                "NEWT_SECRET='"$NEWT_SECRET"'"
            ]
        },
        "Name": "newt"
    }' || { echo "❌ ERROR: Failed to create Newt container"; exit 22; }

echo "✅ Newt container should now be running!"
exec tail -f /dev/null  # Keep container running
