# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Define the Pangolin CLI version (fosrl/cli). The CLI embeds Newt: `pangolin-cli up site`
# accepts the same flags and environment variables as the standalone newt binary.
ARG PANGOLIN_CLI_VERSION=0.21.0
ENV PANGOLIN_CLI_VERSION=${PANGOLIN_CLI_VERSION}
# SHA256 checksums for PANGOLIN_CLI_VERSION above. Must be updated together with PANGOLIN_CLI_VERSION.
# Fetch them with:
#   for a in amd64 arm64 arm32 arm32v6; do printf '%s ' "$a"; \
#     curl -sL "https://github.com/fosrl/cli/releases/download/${PANGOLIN_CLI_VERSION}/pangolin-cli_linux_$a" \
#     | sha256sum | cut -d' ' -f1; done
ARG PANGOLIN_CLI_SHA256_AMD64="c34937dc21f6e447e1023b5e5f36fb2266c997c3866e979a7cead23b4a3736c6"
ARG PANGOLIN_CLI_SHA256_ARM64="4dc81fd11076593452d39c2ce77ad9ba4767115557a012da03aed7450bf23039"
ARG PANGOLIN_CLI_SHA256_ARM32="ca7c53fa6a08921458d9841a5e9d35bf628a7116a607204a8e4820e1b5b5239a"
ARG PANGOLIN_CLI_SHA256_ARM32V6="95fee067073f0938e8c4fc7ec45b81361379fb047a0ba37d28c767375f8eb54d"

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
