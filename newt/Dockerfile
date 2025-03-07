# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Install dependencies
RUN apk add --no-cache bash curl jq

# Install bashio correctly
RUN curl -fsSL https://raw.githubusercontent.com/hassio-addons/bashio/master/install.sh | bash

# Copy the script into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Run the script as the main process
ENTRYPOINT [ "/run.sh" ]
