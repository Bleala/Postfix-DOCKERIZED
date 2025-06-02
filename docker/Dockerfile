### Dockerfile for a Postfix email relay service###

# Alpine Base Image
FROM alpine:3.22.0

# Build Arguments
ARG ALPINE_VERSION="3.21.3" \
        IMAGE_VERSION="1.0.4" \
        POSTFIX_VERSION="3.9.3"

# Copy start script
COPY files/run.sh /

# Install packages and dependencies
RUN apk --no-cache add apk-tools=~2.14.6 \
    && apk --no-cache add bash=~5.2.37 \
    && apk --no-cache add gawk=~5.3.1 \
    && apk --no-cache add cyrus-sasl=~2.1.28 \
    && apk --no-cache add cyrus-sasl-login=~2.1.28 \
    && apk --no-cache add cyrus-sasl-crammd5=~2.1.28 \
    && apk --no-cache add mailx=~8.1.2 \
    && apk --no-cache add postfix=~3.9.4 \
    # Create log directories
    && mkdir -p /var/log/supervisor/ /var/run/supervisor/ \
    # Allow all interfaces
    && sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf \
    # Make start script executable
    && chmod +x /run.sh \
    # Build a new copy of the alias database
    && newaliases

# Labeling
LABEL maintainer="Bleala" \
        version="${IMAGE_VERSION}" \
        description="Postfix ${POSTFIX_VERSION} on Alpine ${ALPINE_VERSION}" \
        org.opencontainers.image.source="https://github.com/Bleala/Postfix-DOCKERIZED" \
        org.opencontainers.image.url="https://github.com/Bleala/Postfix-DOCKERIZED"

# Expose Postfix Port
EXPOSE 25

# Cmd to run
CMD ["/run.sh"]
#ENTRYPOINT ["/run.sh"]
