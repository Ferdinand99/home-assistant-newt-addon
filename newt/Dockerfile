# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Install dependencies
RUN apk add --no-cache bash curl jq

# Manually download and install bashio
RUN mkdir -p /etc/bashio \
    && curl -fsSL -o /etc/bashio/bashio.sh https://raw.githubusercontent.com/hassio-addons/bashio/master/bashio.sh \
    && chmod +x /etc/bashio/bashio.sh \
    && ln -s /etc/bashio/bashio.sh /usr/bin/bashio

# Copy the script into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Run the script as the main process
ENTRYPOINT [ "/run.sh" ]
