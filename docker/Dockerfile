# Global Arguments
ARG ALPINE_VERSION="3.22.2" \
    IMAGE_VERSION="1.1.0" \
    POSTFIX_VERSION="3.10.5"

# Alpine Base Image
FROM alpine:${ALPINE_VERSION} AS postfix

# Set arguments
ARG ALPINE_VERSION \
    IMAGE_VERSION \
    POSTFIX_VERSION

# Install packages and dependencies
RUN apk update && \
    apk add --no-cache \
      apk-tools=~2.14.9 \
      bash=~5.2.37 \
      gawk=~5.3.2 \
      cyrus-sasl=~2.1.28 \
      cyrus-sasl-login=~2.1.28 \
      cyrus-sasl-crammd5=~2.1.28 \
      mailx=~8.1.2 \
      postfix=~3.10.5 && \
    # Create log directories
    mkdir -p /var/log/supervisor/ /var/run/supervisor/ && \
    # Allow all interfaces
    sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf && \
    # Build a new copy of the alias database
    newaliases

# Copy Files
COPY files /files

# Make start script executable
RUN chmod +x /files/run.sh

# Set build date argument here, because caching would break otherwise
# It is set during the build process in the reusable workflow
ARG BUILD_DATE

# Healthcheck to ensure Postfix master process is running
HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=3 \
  CMD postfix status

# Set labels
LABEL org.opencontainers.image.authors="Bleala" \
      org.opencontainers.image.vendor="Bleala" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="Postfix-DOCKERIZED" \
      org.opencontainers.image.description="Postfix - a simple SMTP TLS relay with multiple (possible) use cases. DOCKERIZED!" \
      org.opencontainers.image.documentation="https://unbound.docs.nlnetlabs.nl/en/latest/" \
      org.opencontainers.image.url="https://github.com/Bleala/Postfix-DOCKERIZED" \
      org.opencontainers.image.source="https://github.com/Bleala/Postfix-DOCKERIZED"

# Expose Postfix Ports
# Port 25: SMTP (opportunistic STARTTLS)
# Port 465: SMTPS (Implicit TLS)
# Port 587: Submission (STARTTLS)
EXPOSE 25 465 587

# Cmd to run
CMD ["/files/run.sh"]
#ENTRYPOINT ["/files/run.sh"]
