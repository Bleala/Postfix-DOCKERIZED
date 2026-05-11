# Global Arguments
ARG ALPINE_VERSION="3.23.4" \
    IMAGE_VERSION="1.1.1" \
    POSTFIX_VERSION="3.10.9"

# Alpine Base Image
FROM alpine:${ALPINE_VERSION} AS postfix

# Set arguments
ARG ALPINE_VERSION \
    IMAGE_VERSION \
    POSTFIX_VERSION

# Set shell options
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# Healthcheck to ensure Postfix master process is running
HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 \
  CMD postfix status

# Install packages and dependencies
RUN apk add --no-cache \
      apk-tools \
      bash \
      gawk \
      cyrus-sasl \
      cyrus-sasl-login \
      cyrus-sasl-crammd5 \
      mailx \
      postfix && \
    # Create log directories
    mkdir -p /var/log/supervisor/ /var/run/supervisor/ && \
    # Allow all interfaces
    sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf && \
    # Build a new copy of the alias database
    newaliases

# Copy Files
COPY --chmod=755 files /files

# Set build date argument here, because caching would break otherwise
# It is set during the build process in the reusable workflow
ARG BUILD_DATE

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
