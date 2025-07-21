### Dockerfile for a Postfix email relay service###

# Alpine Base Image
FROM alpine:3.22.1

# Build Arguments
ARG ALPINE_VERSION="3.22.0" \
        BUILD_DATE="2025-06-11T12:00:00Z" \
        IMAGE_VERSION="1.0.4" \
        POSTFIX_VERSION="3.10.2"

# Set labels
LABEL org.opencontainers.image.authors="Bleala" \
      org.opencontainers.image.vendor="Bleala" \
      org.opencontainers.image.version="${POSTFIX_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="Postfix-DOCKERIZED" \
      org.opencontainers.image.description="Postfix - a simple SMTP TLS relay with no local authentication enabled. DOCKERIZED!" \
      org.opencontainers.image.documentation="https://unbound.docs.nlnetlabs.nl/en/latest/" \
      org.opencontainers.image.url="https://github.com/Bleala/Postfix-DOCKERIZED" \
      org.opencontainers.image.source="https://github.com/Bleala/Postfix-DOCKERIZED"

# Copy Files
COPY files /files

# Install packages and dependencies
RUN apk --no-cache add apk-tools=~2.14.9 \
    && apk --no-cache add bash=~5.2.37 \
    && apk --no-cache add gawk=~5.3.2 \
    && apk --no-cache add cyrus-sasl=~2.1.28 \
    && apk --no-cache add cyrus-sasl-login=~2.1.28 \
    && apk --no-cache add cyrus-sasl-crammd5=~2.1.28 \
    && apk --no-cache add mailx=~8.1.2 \
    && apk --no-cache add postfix=~3.10.2 \
    # Create log directories
    && mkdir -p /var/log/supervisor/ /var/run/supervisor/ \
    # Allow all interfaces
    && sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf \
    # Make start script executable
    && chmod +x /files/run.sh \
    # Build a new copy of the alias database
    && newaliases

# Expose Postfix Port
EXPOSE 25

# Cmd to run
CMD ["/files/run.sh"]
#ENTRYPOINT ["/files/run.sh"]
