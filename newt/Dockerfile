# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Install bashio (required for reading Home Assistant options)
RUN apk add --no-cache bash curl jq \
    && curl -fsSL https://raw.githubusercontent.com/hassio-addons/bashio/master/install.sh | bashio

# Copy the script into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Run the script as the main process
ENTRYPOINT [ "/run.sh" ]
