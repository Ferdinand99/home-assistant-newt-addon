# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Install dependencies
RUN apk add --no-cache bash curl jq

# Detect system architecture and download the correct Newt binary
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/1.5.1/newt_linux_amd64; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/1.5.1/newt_linux_arm64; \
    elif [ "$ARCH" = "armv7l" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/1.5.1/newt_linux_arm32; \
    elif [ "$ARCH" = "armv6l" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/1.5.1/newt_linux_arm32v6; \
    elif [ "$ARCH" = "riscv64" ]; then \
        curl -fsSL -o /usr/bin/newt https://github.com/fosrl/newt/releases/download/1.5.1/newt_linux_riscv64; \
    else \
        echo "❌ ERROR: Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    chmod +x /usr/bin/newt


# Copy the script into the container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Run the script as the main process
ENTRYPOINT [ "/run.sh" ]
