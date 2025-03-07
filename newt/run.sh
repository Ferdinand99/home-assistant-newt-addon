#!/usr/bin/env bash
set -e  # Stop the script on errors

echo "🔹 Starting Newt container using Home Assistant OS..."

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ ERROR: Docker is NOT available inside Home Assistant OS!"
    exit 1
fi
echo "✅ Docker is available!"

# Retrieve environment variables
PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT:-"https://dash.opland.net"}
NEWT_ID=${NEWT_ID:-"ru32vsg8ls5lx93"}
NEWT_SECRET=${NEWT_SECRET:-"5rbqgpc292989uk9kz52hmypoyz6u9jf7k670fqja8p4un8o"}

echo "🔹 Environment Variables:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Remove old Newt container if it exists
if docker ps -a --format '{{.Names}}' | grep -q "newt"; then
    echo "🔹 Stopping and removing existing Newt container..."
    docker stop newt
    docker rm newt
fi

# Run the Newt container
echo "🔹 Starting Newt container..."
docker run -d --restart unless-stopped \
    --name newt \
    -e PANGOLIN_ENDPOINT="$PANGOLIN_ENDPOINT" \
    -e NEWT_ID="$NEWT_ID" \
    -e NEWT_SECRET="$NEWT_SECRET" \
    fosrl/newt || { echo "❌ ERROR: Failed to start Newt container"; exit 22; }

echo "✅ Newt container started successfully!"
exec tail -f /dev/null  # Keep the add-on running
