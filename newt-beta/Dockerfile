# Use the official Home Assistant add-on base image
FROM ghcr.io/hassio-addons/base:14.0.0

# Define the Newt version
ARG NEWT_VERSION=1.16.0
ENV NEWT_VERSION=${NEWT_VERSION}
# SHA256-summer for NEWT_VERSION ovenfor. Må oppdateres sammen med NEWT_VERSION.
# Hentes med:
#   for a in amd64 arm64 arm32 arm32v6; do printf '%s ' "$a"; \
#     curl -sL "https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_$a" \
#     | sha256sum | cut -d' ' -f1; done
ARG NEWT_SHA256_AMD64="edb2e3d68549e009efdd461939db80c8ae43915fae89de8a332f8a29e00c92a8"
ARG NEWT_SHA256_ARM64="2be3a8122478330471d531fcc5668519d20654550a9e6a9fa2f76b89e15de965"
ARG NEWT_SHA256_ARM32="77c47b0f08cb588f9c5ec0fd9cfb541fb9df1d591fde0e8db7e5141285c503e4"
ARG NEWT_SHA256_ARM32V6="8341550fdecec1cdbd8b09a4bd964028bb893d45482b222da4b436b62516bf35"

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
    elif [ "${BUILD_ARCH}" = "armv7" ]; then \
        DOWNLOAD_URL="https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm32"; \
        EXPECTED_SHA="${NEWT_SHA256_ARM32}"; \
    elif [ "${BUILD_ARCH}" = "armhf" ]; then \
        # armhf er ARMv6 i Home Assistant og trenger v6-binæren, ikke arm32 (v7)
        DOWNLOAD_URL="https://github.com/fosrl/newt/releases/download/${NEWT_VERSION}/newt_linux_arm32v6"; \
        EXPECTED_SHA="${NEWT_SHA256_ARM32V6}"; \
    else \
        echo "❌ ERROR: Unsupported Home Assistant architecture: ${BUILD_ARCH}"; exit 1; \
    fi && \
    echo "🔹 Downloading Newt for ${BUILD_ARCH} from ${DOWNLOAD_URL}..." && \
    curl --ipv4 --proto '=https' --tlsv1.2 --retry 3 --retry-delay 2 --fail --silent --show-error -L -o /usr/bin/newt "$DOWNLOAD_URL" && \
    if [ -z "$EXPECTED_SHA" ]; then \
        echo "❌ ERROR: No SHA256 configured for ${BUILD_ARCH}; refusing to ship an unverified binary"; exit 1; \
    fi && \
    # Viktig: Nøyaktig to standard mellomrom mellom hash og filbane
    echo "${EXPECTED_SHA}  /usr/bin/newt" | sha256sum -c - && \
    chmod +x /usr/bin/newt && \
    apk del .build-deps

# Copy and prepare run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Docker healthcheck. Newt eier helsefilen selv: den skrives når tunnel-pingen
# lykkes og fjernes når forbindelsen mistes. start-period gir tunnelen tid til
# å komme opp før containeren kan bli markert unhealthy.
HEALTHCHECK --interval=30s --timeout=5s --retries=3 --start-period=60s \
  CMD test -f "$HEALTH_FILE" || exit 1

# Start the add-on
ENTRYPOINT ["/run.sh"]
