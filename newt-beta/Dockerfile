# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Define the Pangolin CLI version (fosrl/cli). The CLI embeds Newt: `pangolin-cli up site`
# accepts the same flags and environment variables as the standalone newt binary.
ARG PANGOLIN_CLI_VERSION=0.22.0
ENV PANGOLIN_CLI_VERSION=${PANGOLIN_CLI_VERSION}
# SHA256 checksums for PANGOLIN_CLI_VERSION above. Must be updated together with PANGOLIN_CLI_VERSION.
# Fetch them with:
#   for a in amd64 arm64 arm32 arm32v6; do printf '%s ' "$a"; \
#     curl -sL "https://github.com/fosrl/cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_$a" \
#     | sha256sum | cut -d' ' -f1; done
ARG PANGOLIN_CLI_SHA256_AMD64="882b09745cd53b3cb953242ed3a74d1517a21f40fb530a86befc45fe0bebfa77"
ARG PANGOLIN_CLI_SHA256_ARM64="d3f9de117c52dc36ea6130d2e1d0ff5a325d81c4b22b4e2cf1a29f4d3b335209"
ARG PANGOLIN_CLI_SHA256_ARM32="8a4a42c387cb579076e98233db14e5e6fc618dd2aa018a40620613d69ee48ea4"
ARG PANGOLIN_CLI_SHA256_ARM32V6="d998269c16886b7bfaa028dc2485b07a4e6eb6d4a24a806b64f0309e5cc94de1"

# Enable the health file (written by the embedded Newt once the tunnel is up)
ENV HEALTH_FILE=/tmp/healthy

# Install runtime dependencies and temporary build tooling
RUN apk add --no-cache bash jq && apk add --no-cache --virtual .build-deps curl

# Use Home Assistant's built-in BUILD_ARCH for safe architecture detection
ARG BUILD_ARCH
RUN \
    if [ "${BUILD_ARCH}" = "amd64" ]; then \
        DOWNLOAD_URL="https://github.com/fosrl/cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_amd64"; \
        EXPECTED_SHA="${PANGOLIN_CLI_SHA256_AMD64}"; \
    elif [ "${BUILD_ARCH}" = "aarch64" ]; then \
        DOWNLOAD_URL="https://github.com/fosrl/cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_arm64"; \
        EXPECTED_SHA="${PANGOLIN_CLI_SHA256_ARM64}"; \
    elif [ "${BUILD_ARCH}" = "armv7" ]; then \
        DOWNLOAD_URL="https://github.com/fosrl/cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_arm32"; \
        EXPECTED_SHA="${PANGOLIN_CLI_SHA256_ARM32}"; \
    elif [ "${BUILD_ARCH}" = "armhf" ]; then \
        # armhf is ARMv6 in Home Assistant and needs the v6 binary, not arm32 (v7)
        DOWNLOAD_URL="https://github.com/fosrl/cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_arm32v6"; \
        EXPECTED_SHA="${PANGOLIN_CLI_SHA256_ARM32V6}"; \
    else \
        echo "❌ ERROR: Unsupported Home Assistant architecture: ${BUILD_ARCH}"; exit 1; \
    fi && \
    echo "🔹 Downloading Pangolin CLI for ${BUILD_ARCH} from ${DOWNLOAD_URL}..." && \
    curl --ipv4 --proto '=https' --tlsv1.2 --retry 3 --retry-delay 2 --fail --silent --show-error -L -o /usr/bin/pangolin-cli "$DOWNLOAD_URL" && \
    if [ -z "$EXPECTED_SHA" ]; then \
        echo "❌ ERROR: No SHA256 configured for ${BUILD_ARCH}; refusing to ship an unverified binary"; exit 1; \
    fi && \
    # Important: exactly two regular spaces between the hash and the file path
    echo "${EXPECTED_SHA}  /usr/bin/pangolin-cli" | sha256sum -c - && \
    chmod +x /usr/bin/pangolin-cli && \
    apk del .build-deps

# Copy and prepare run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Docker healthcheck. The CLI (embedded Newt) owns the health file itself: it's written when the tunnel
# ping succeeds and removed when the connection is lost. start-period gives the tunnel
# time to come up before the container can be marked unhealthy.
HEALTHCHECK --interval=30s --timeout=5s --retries=3 --start-period=60s \
  CMD test -f "$HEALTH_FILE" || exit 1

# Start the add-on
ENTRYPOINT ["/run.sh"]
