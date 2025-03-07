#!/usr/bin/env bash
set -e  # Stop the script on errors

echo "🔹 Starting Newt inside Home Assistant OS..."

# Load configuration values
PANGOLIN_ENDPOINT=${PANGOLIN_ENDPOINT:-"https://dash.opland.net"}
NEWT_ID=${NEWT_ID:-"your_newt_id"}
NEWT_SECRET=${NEWT_SECRET:-"your_newt_secret"}

echo "✅ Configuration Loaded:"
echo "  PANGOLIN_ENDPOINT=$PANGOLIN_ENDPOINT"
echo "  NEWT_ID=$NEWT_ID"
echo "  NEWT_SECRET=$NEWT_SECRET"

# Run Newt inside the add-on container
echo "🔹 Running Newt..."
/usr/bin/newt --id "$NEWT_ID" --secret "$NEWT_SECRET" --endpoint "$PANGOLIN_ENDPOINT" &

echo "✅ Newt is running!"
exec tail -f /dev/null  # Keep the add-on running
