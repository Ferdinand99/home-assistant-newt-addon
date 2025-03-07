# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Install dependencies
RUN apk add --no-cache bash curl jq

# Download and install Newt
RUN curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/1.0.0/newt_linux_amd64 \
    && chmod +x /usr/bin/newt

# Copy the script into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Run the script as the main process
ENTRYPOINT [ "/run.sh" ]
