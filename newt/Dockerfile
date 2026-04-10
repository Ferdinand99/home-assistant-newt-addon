# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Define the Newt version
ARG NEWT_VERSION=1.11.0
ENV NEWT_VERSION=${NEWT_VERSION}

# Enable Newt health file
ENV HEALTH_FILE=/tmp/healthy

# Install dependencies
RUN apk add --no-cache bash curl jq

# Detect system architecture and download the correct Newt binary
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_amd64; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm64; \
    elif [ "$ARCH" = "armv7l" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm32; \
    elif [ "$ARCH" = "armv6l" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm32v6; \
    elif [ "$ARCH" = "riscv64" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_riscv64; \
    else \
        echo "❌ ERROR: Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    chmod +x /usr/bin/newt

# Copy and prepare run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Docker healthcheck
HEALTHCHECK --interval=5s --timeout=2s --retries=2 --start-period=10s \
  CMD test -f /tmp/healthy || exit 1

# Start the add-on
ENTRYPOINT ["/run.sh"]
