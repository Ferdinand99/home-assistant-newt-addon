# Use the correct Home Assistant base image that includes bashio
FROM ghcr.io/home-assistant/amd64-base:3.18

# Install dependencies
RUN apk add --no-cache bash curl jq

# Copy the script into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Run the script as the main process
ENTRYPOINT [ "/run.sh" ]
