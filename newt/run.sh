#!/usr/bin/env bash
set -e

echo "Starting Newt container using Home Assistant Supervisor API..."

# Load config from environment variables
PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT:-"https://example.com"}
NEWT_ID=${NEWT_ID:-"default_id"}
NEWT_SECRET=${NEWT_SECRET:-"default_secret"}

# Define the Supervisor API endpoint
SUPERVISOR_API="http://supervisor/docker"

# Check if we have access to the Home Assistant Supervisor API
if ! curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" "${SUPERVISOR_API}/info"; then
    echo "Supervisor API is not accessible. Ensure the add-on has access to the Supervisor API."
    exit 1
fi

# Stop and remove any existing Newt container
echo "Stopping and removing any existing Newt container..."
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "${SUPERVISOR_API}/containers/newt/stop" || true
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "${SUPERVISOR_API}/containers/newt/remove" || true

# Start a new Newt container using the Supervisor API
echo "Starting new Newt container..."
curl --silent --fail --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" \
    -X POST "${SUPERVISOR_API}/containers/create" \
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
    }'

echo "Newt container started successfully!"

# Keep the script running to prevent add-on from exiting
exec tail -f /dev/null