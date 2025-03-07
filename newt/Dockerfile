# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Set the correct Shell for Home Assistant add-ons
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install necessary dependencies (if needed)
RUN apk add --no-cache docker-cli bash

# Copy the script into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Run the script as the main process
ENTRYPOINT [ "/run.sh" ]