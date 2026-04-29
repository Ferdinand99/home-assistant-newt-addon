# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Define the Newt version
ARG NEWT_VERSION=1.12.2
ENV NEWT_VERSION=${NEWT_VERSION}
ARG NEWT_SHA256_AMD64=""
ARG NEWT_SHA256_ARM64=""
ARG NEWT_SHA256_ARM32=""
ARG NEWT_SHA256_ARM32V6=""
ARG NEWT_SHA256_RISCV64=""

# Enable Newt health file
ENV HEALTH_FILE=/tmp/healthy

# Install runtime dependencies and temporary build tooling
RUN apk add --no-cache bash jq && apk add --no-cache --virtual .build-deps curl

# Bruk Home Assistants innebygde BUILD_ARCH for sikker arkitekturdeteksjon
ARG BUILD_ARCH
RUN \
    if [ "${BUILD_ARCH}" = "amd64" ]; then \
        DOWNLOAD_URL="https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_amd64"; \
        EXPECTED_SHA="${NEWT_SHA256_AMD64}"; \
    elif [ "${BUILD_ARCH}" = "aarch64" ]; then \
        DOWNLOAD_URL="https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm64"; \
        EXPECTED_SHA="${NEWT_SHA256_ARM64}"; \
    elif [ "${BUILD_ARCH}" = "armv7" ] || [ "${BUILD_ARCH}" = "armhf" ]; then \
        DOWNLOAD_URL="https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm32"; \
        EXPECTED_SHA="${NEWT_SHA256_ARM32}"; \
    else \
        echo "❌ ERROR: Unsupported Home Assistant architecture: ${BUILD_ARCH}"; exit 1; \
    fi && \
    echo "🔹 Downloading Newt for ${BUILD_ARCH} from ${DOWNLOAD_URL}..." && \
    curl --ipv4 --proto '=https' --tlsv1.2 --retry 3 --retry-delay 2 --fail --silent --show-error -L -o /usr/bin/newt "$DOWNLOAD_URL" && \
    if [ -n "$EXPECTED_SHA" ]; then \
        # Viktig: Nøyaktig to standard mellomrom mellom hash og filbane
        echo "${EXPECTED_SHA}  /usr/bin/newt" | sha256sum -c -; \
    else \
        echo "⚠️ WARNING: No SHA256 provided for ${BUILD_ARCH}; skipping checksum verification"; \
    fi && \
    chmod +x /usr/bin/newt && \
    apk del .build-deps

# Copy and prepare run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Docker healthcheck
HEALTHCHECK --interval=5s --timeout=2s --retries=2 --start-period=10s \
  CMD test -f /tmp/healthy || exit 1

# Start the add-on
ENTRYPOINT ["/run.sh"]
