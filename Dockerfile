FROM ghcr.io/hassio-addons/base:14.0.0

# Install dependencies
RUN apk add --no-cache docker-cli

# Copy the run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
