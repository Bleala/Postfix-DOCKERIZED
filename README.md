# [Postfix](https://www.postfix.org/documentation.html "Official Documentation")-DOCKERIZED

[![GitHub Release](https://img.shields.io/github/v/release/Bleala/Postfix-DOCKERIZED?style=flat-square&label=Version)](https://github.com/Bleala/Postfix-DOCKERIZED/releases)
[![Docker Stars](https://img.shields.io/docker/stars/bleala/postfix?style=flat-square&label=Docker%20Stars)](https://hub.docker.com/r/bleala/postfix/)
[![Docker Pulls](https://img.shields.io/docker/pulls/bleala/postfix?style=flat-square&label=Docker%20Pulls)](https://hub.docker.com/r/bleala/postfix/)
[![Container Build Check 🐳✅](https://github.com/Bleala/Postfix-DOCKERIZED/actions/workflows/container-build-check.yaml/badge.svg)](https://github.com/Bleala/Postfix-DOCKERIZED/actions/workflows/container-build-check.yaml)

A simple [Postfix](https://www.postfix.org/ "Postfix Homepage") SMTP TLS relay docker [Alpine Linux](https://hub.docker.com/_/alpine "Alpine Linux Image") based image with multiple (possible) use cases.

This image supports inbound TLS (STARTTLS/SMTPS) and optional SASL authentication for clients, with multiple configurable security modes (IP based, authentication based or mTLS).

## About Postfix

**Disclaimer:** I am just the maintainer of this docker container, I did not write the software. Visit the [Official Homepage](https://www.postfix.org/ "Postfix Homepage") to thank the author(s)! :)

**Info:** I originally forked this repositofy from [Juan Luis Baptiste](https://github.com/juanluisbaptiste/ "Juan Luis Baptiste"). Thank you for your work! :)

What is Postfix? It is Wietse Venema's mail server that started life at IBM research as an alternative to the widely-used Sendmail program. After eight years at Google, Wietse continues to maintain Postfix.

Postfix attempts to be fast, easy to administer, and secure. The outside has a definite Sendmail-ish flavor, but the inside is completely different.

Official Website - <https://www.postfix.org/>

Docs - <https://www.postfix.org/documentation.html>

My Github Repository - <https://github.com/Bleala/Postfix-DOCKERIZED>

Docker Hub - <https://hub.docker.com/r/bleala/postfix>

---

## Image, Versions and Architecture

I built this image based on [Alpine Linux](https://hub.docker.com/_/alpine "Alpine Linux Image").

There will always be two different versions:

| Tag | Content |
| ------------- |:-------------:|
| Latest    | Contains the latest stable version |
| x.x.x     | Contains the Postfix and Alpine versions mentioned at the bottom of the page and in the release notes |

I am using semantic versioning for this image. For all supported architectures there are the following versioned tags:

* Major (1)
* Minor (1.0)
* Patch (1.0.0)
* Latest

There are also several platforms supported:

Platform:

* linux/amd64
* linux/386
* linux/arm64
* linux/arm/v6
* linux/arm/v7

---

## Image Signing & Verification

To ensure the authenticity and integrity of my images, all `bleala/postfix` images pushed to `Docker Hub` and `GitHub Container Registry` (and maybe more in the future) are signed using [Cosign](https://github.com/sigstore/cosign "Cosign").

I use a static key pair for signing. The public key required for verification, `cosign.pub`, is available in the root of this GitHub repository:

* **Public Key:** [`cosign.pub`](https://github.com/Bleala/Postfix-DOCKERIZED/blob/main/cosign.pub "cosign.pub")

### How to Verify an Image

You can verify the signature of an image to ensure it hasn't been tampered with and originates from me.

1. **Install Cosign:**
    If you don't have Cosign installed, follow the official installation instructions: [Cosign Installation Guide](https://docs.sigstore.dev/cosign/system_config/installation/ "Cosign Installation Guide").

2. **Obtain the Public Key:**
    Download the [`cosign.pub`](https://github.com/Bleala/Postfix-DOCKERIZED/blob/main/cosign.pub "cosign.pub") file from this repository or clone the repository to access it locally.

3. **Verify the Image:**
    Use the `cosign verify` command. It is highly recommended to verify against the image **digest** (e.g., `sha256:...`) rather than a mutable tag (like `latest` or `1.23.0`). You can find image digests on Docker Hub or GitHub Container Registry.

    ```bash
    # Ensure 'cosign.pub' is in your current directory, or provide the full path to it.
    # Replace <registry>/bleala/postfix@sha256:<image-digest> with the actual image reference and its digest.

    # Example for an image on Docker Hub:
    cosign verify --key cosign.pub docker.io/bleala/postfix@sha256:<ACTUAL_IMAGE_DIGEST_HERE>

    # Example for an image on GitHub Container Registry:
    cosign verify --key cosign.pub ghcr.io/bleala/postfix@sha256:<ACTUAL_IMAGE_DIGEST_HERE>
    ```

    For instance, to verify the `dev` tag with the following digest `sha256:961ca387d48611241720d18895ae9a5f8434e61757dc5c0aeff7aed3b632dd12`:

    ```bash
    cosign verify --key cosign.pub docker.io/bleala/postfix@sha256:961ca387d48611241720d18895ae9a5f8434e61757dc5c0aeff7aed3b632dd12
    ```

    A successful verification will output information like this:

    ```bash
    cosign verify --key cosign.pub docker.io/bleala/postfix@sha256:961ca387d48611241720d18895ae9a5f8434e61757dc5c0aeff7aed3b632dd12

    Verification for index.docker.io/bleala/postfix@sha256:961ca387d48611241720d18895ae9a5f8434e61757dc5c0aeff7aed3b632dd12 --
    The following checks were performed on each of these signatures:
      - The cosign claims were validated
      - Existence of the claims in the transparency log was verified offline
      - The signatures were verified against the specified public key

    [{"critical":{"identity":{"docker-reference":"index.docker.io/bleala/postfix"},"image":{"docker-manifest-digest":"sha256:961ca387d48611241720d18895ae9a5f8434e61757dc5c0aeff7aed3b632dd12"},"type":"cosign container image signature"},"optional":{"Bundle":{"SignedEntryTimestamp":"MEYCIQD0TrPhm+mdR7+Dcrpjxo16Xdoa1YugMKEVRTToNA4B+gIhAPo0NmutqMtN58y2SVSp4hlA30qhmrpRzZod/MRrEq7a","Payload":{"body":"eyJhcGlWZXJzaW9uIjoiMC4wLjEiLCJraW5kIjoiaGFzaGVkcmVrb3JkIiwic3BlYyI6eyJkYXRhIjp7Imhhc2giOnsiYWxnb3JpdGhtIjoic2hhMjU2IiwidmFsdWUiOiJlYzg4OGIzY2ZlZDgyNzgxMzI1MGM0MDUyYTExNGNkZDhiZmFkY2ViNTI4MzliMGZkNjM2YjE4ZDNjZGUzMTNlIn19LCJzaWduYXR1cmUiOnsiY29udGVudCI6Ik1FVUNJUUROUnF1azdMRnV4cWMzZWRub2dJbmZKd2wyN0UyeWFnNjd1MlhPeXoyMDJRSWdlLysvYWtzMmVyUC9GalhrdUVFME93RHpSOW9KOXhOWXIrMXcyVmZ1cmpVPSIsInB1YmxpY0tleSI6eyJjb250ZW50IjoiTFMwdExTMUNSVWRKVGlCUVZVSk1TVU1nUzBWWkxTMHRMUzBLVFVacmQwVjNXVWhMYjFwSmVtb3dRMEZSV1VsTGIxcEplbW93UkVGUlkwUlJaMEZGU0VWWFRFYzVjVVI2VFdGdlJ6TlJTSGxXTUhoVFRVZzNRblF3VGdvMVRVWkRNWEV3VFhabE5DOHZVMmwxZVZWbU5VRnBaRVJZY2s5S1kwaEdSalYxZERWUVMyNVViMUZ6YjNWNWRGVTBXVmhoWlM5bU1UQlJQVDBLTFMwdExTMUZUa1FnVUZWQ1RFbERJRXRGV1MwdExTMHRDZz09In19fX0=","integratedTime":1756721445,"logIndex":455914577,"logID":"c0d23d6ad406973f9559f3ba2d1ca01f84147d8ffc5b8445c224f98b9591801d"}}}}]
    ```

---

## Usage

To start the container you can run the following:

```bash
docker run -d --name postfix -p "25:25"  \
        -e SMTP_SERVER=your.mail.server \
        -e SERVER_HOSTNAME=your.mail.server \
        bleala/postfix:latest
```

But since docker compose is easier to maintain, I'll give you a valid docker compose example:

```docker-compose.yml
---
networks:
  postfix:
    name: postfix
    driver: bridge

secrets:
  smtp_password:
    file: $SECRETSDIR/smtp_password

services:
  # Postfix SMTP Relay - Simple Postfix SMTP TLS relay docker alpine based image with multiple (possible) use cases.
  # https://hub.docker.com/r/bleala/postfix/
  # https://github.com/Bleala/Postfix-DOCKERIZED
  postfix:
    image: bleala/postfix:latest
    container_name: postfix
    hostname: postfix
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    env_file:
      - path: .env
        required: false
    environment:
      SERVER_HOSTNAME: mail.example.com
      SMTP_SERVER: mail.example.com
      SMTP_PORT: 465
      SMTP_USERNAME: user@example.com
      SMTP_PASSWORD_FILE: /run/secrets/smtp_password
      SMTP_NETWORKS: 192.168.0.1/24
      LOG_SUBJECT: yes
    networks:
      postfix: {}
    ports:
      - target: 25
        published: 25
        protocol: tcp
        mode: host
    volumes:
      - type: bind
        source: /etc/localtime
        target: /etc/localtime
        read_only: true
    secrets:
      - source: smtp_password
```

If you want to configure inbound TLS, SASL authentication and/or mTLS here is a full blown docker compose example:

```docker compose.yml
---
networks:
  postfix:
    name: postfix
    driver: bridge

secrets:
  smtp_password:
    file: /path/to/your/secret/file/smtp_password
  smtp_username:
    file: /path/to/your/secret/file/smtp_username
  smtpd_auth_password:
    file: /path/to/your/secret/file/smtpd_auth_password
  smtpd_auth_username:
    file: /path/to/your/secret/file/smtpd_auth_username

services:
  # Postfix SMTP Relay - Simple Postfix SMTP TLS relay docker alpine based image with multiple (possible) use cases.
  # https://hub.docker.com/r/bleala/postfix
  # https://github.com/Bleala/Postfix-DOCKERIZED
  postfix:
    image: bleala/postfix:latest
    container_name: postfix
    hostname: postfix
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    env_file:
      - path: .env
        required: false
    environment:
      ### Outbound Relay Configuration ###
      # Mandatory: Server hostname for the Postfix container. Emails will appear to come from the hostname's domain.
      SERVER_HOSTNAME: 'mail.example.com'
      # Mandatory: Server address of the SMTP server to use.
      SMTP_SERVER: 'mail.example.com'
      # Optional: (Default value: 587) Port address of the SMTP server to use.
      SMTP_PORT: '25'
      # Optional: Username to authenticate with. (Not needed if SMTP_USERNAME_FILE is used)
      SMTP_USERNAME: 'my_user'
      # Optional (Mandatory if SMTP_USERNAME is set): Password of the SMTP user. (Not needed if SMTP_PASSWORD_FILE is used)
      SMTP_PASSWORD: 'my_password'
      # Optional: Set this to a mounted file containing the username, to avoid usernames in env variables.
      SMTP_USERNAME_FILE: '/run/secrets/smtp_username'
      # Optional: Set this to a mounted file containing the password, to avoid passwords in env variables.
      SMTP_PASSWORD_FILE: '/run/secrets/smtp_password'
      # Optional: Path to a file (PEM) containing trusted CAs for verifying the OUTBOUND server (SMTP_SERVER).
      # Use either SMTP_TLS_CA_FILE or SMTP_TLS_CA_PATH.
      SMTP_TLS_CA_FILE: '/etc/postfix/certs/my-homelab-ca.crt'
      # Optional: Path to a directory containing trusted CAs (PEM) for verifying the OUTBOUND server (SMTP_SERVER).
      # Use either SMTP_TLS_CA_FILE or SMTP_TLS_CA_PATH.
      SMTP_TLS_CA_PATH: '/etc/postfix/certs/ca-directory'

      ### IP & SASL Authentication Configuration ###
      # Optional: Setting this will allow you to add additional, comma seperated, subnets to use the relay. Used like SMTP_NETWORKS='xxx.xxx.xxx.xxx/xx,xxx.xxx.xxx.xxx/xx'.
      SMTP_NETWORKS: ''
      # Optional: Set the security mode for inbound relaying.
      # 'mynetworks_only': (Default) Only clients from SMTP_NETWORKS can relay. SASL is disabled.
      # 'sasl_only': Only authenticated SASL users can relay. Client IP is ignored.
      # 'ip_or_sasl': Clients from SMTP_NETWORKS OR authenticated SASL users can relay.
      # 'ip_and_sasl': Clients must be from SMTP_NETWORKS AND be authenticated SASL users.
      # 'mtls_only': Only clients with a valid, trusted certificate (via SMTPD_TLS_CA_FILE/PATH) can relay.
      # 'ip_and_mtls': Clients must be from SMTP_NETWORKS AND have a valid, trusted certificate.
      SMTPD_AUTH_MODE: 'mynetworks_only'
      # Optional: (Mandatory for SASL modes) Username for inbound SASL authentication. (Not needed if SMTPD_AUTH_USERNAME_FILE is used)
      # Set without FQDN, as DOMAIN is appended automatically from SERVER_HOSTNAME.
      SMTPD_AUTH_USERNAME: 'my_user'
      # Optional: (Mandatory for SASL modes) Password for inbound SASL authentication. (Not needed if SMTPD_AUTH_PASSWORD_FILE is used)
      SMTPD_AUTH_PASSWORD: 'my_password'
      # Optional: Set this to a mounted file containing the inbound auth username, to avoid usernames in env variables.
      # Set without FQDN, as DOMAIN is appended automatically from SERVER_HOSTNAME.
      SMTPD_AUTH_USERNAME_FILE: '/run/secrets/smtpd_auth_username'
      # Optional: Set this to a mounted file containing the inbound auth password, to avoid passwords in env variables.
      SMTPD_AUTH_PASSWORD_FILE: '/run/secrets/smtpd_auth_password'
      # Optional: (Default: yes) Set to 'no' to create the SASL user without appending the domain (e.g., 'user' instead of 'user@domain.com').
      SMTPD_AUTH_APPEND_DOMAIN: 'yes'

      ### Inbound TLS Configuration ###
      # Optional: (Default: no) Set to 'yes' to enable inbound STARTTLS (Port 25) and SMTPS (Port 465) and Submission (Port 587).
      SMTPD_TLS_ENABLED: 'yes'
      # Optional: (Default: no) Set to 'yes' to force *global* TLS encryption (smtpd_tls_security_level=encrypt).
      # This will break clients on Port 25 that do not support STARTTLS. Only use in controlled environments.
      SMTPD_TLS_FORCED: 'no'
      # Optional (Mandatory if SMTPD_TLS_ENABLED is 'yes'): (Default: /etc/postfix/certs/chain.pem) Path inside the container to your combined TLS chain file.
      # This file MUST contain (in this order): 1. Private Key, 2. Server Certificate, 3. Intermediate CA(s)
      # Example: cat privkey.pem fullchain.pem > /path/to/your/certs/chain.pem
      # Can be multiple keys/certs combined in one file.
      SMTPD_TLS_CHAIN_FILE: '/etc/postfix/certs/chain.pem'
      # Optional: Path to a file containing trusted CAs (PEM format) for verifying client certificates (mTLS) (Required for 'mtls_only' or 'ip_and_mtls' modes).
      # Use either SMTPD_TLS_CA_FILE or SMTPD_TLS_CA_PATH.
      SMTPD_TLS_CA_FILE: '/etc/postfix/certs/my-homelab-ca.crt'
      # Optional: Path to a directory containing trusted CAs (PEM format) for verifying client certificates (mTLS) (Required for 'mtls_only' or 'ip_and_mtls' modes).
      # Use either SMTPD_TLS_CA_FILE or SMTPD_TLS_CA_PATH.
      SMTPD_TLS_CA_PATH: '/etc/postfix/certs/ca-directory'
      # Optional: (Default: no) Set to 'yes' to enable modern TLS hardening (force TLSv1.2+, high ciphers, server preference, authentication only over TLS).
      TLS_HARDENING_ENABLED: 'yes'

      ### Rate Limiting Options ###
      # Optional: (Default: unset) Max connections per minute from the same client.
      SMTPD_CLIENT_CONN_RATE_LIMIT: '20'
      # Optional: (Default: unset) Max messages per minute from the same client.
      SMTPD_CLIENT_MSG_RATE_LIMIT: '50'
      # Optional: (Default: unset) Max recipients per minute from the same client.
      SMTPD_CLIENT_RCPT_RATE_LIMIT: '100'

      ### Misc. Options ###
      # Optional: (Default: no) Set to 'yes' to enable debug logging.
      DEBUG: 'yes'
      # Optional: This will add a header for tracking messages upstream. Helpful for spam filters. Will appear as "RelayTag: ${SMTP_HEADER_TAG}" in the email headers.
      SMTP_HEADER_TAG: ''
      # Optional: Set this to yes to always add missing From:, To:, Date: or Message-ID: headers.
      ALWAYS_ADD_MISSING_HEADERS: 'yes'
      # Optional: This will rewrite the from address overwriting it with the specified address for all email being relayed.
      OVERWRITE_FROM: "Your Name <email@company.com>"
      # Optional: This will allow you to set a custom $mydestination value. Default is localhost.
      DESTINATION: ''
      # Optional: This will output the subject line of messages in the log.
      LOG_SUBJECT: 'yes'
      # Optional: (Default: yes) This will disable (no) or enable (yes) the use of SMTPUTF8
      SMTPUTF8_ENABLE: 'no'
      # Optional: This will allow you to set a custom $message_size_limit value. Default is 10240000.
      MESSAGE_SIZE_LIMIT: ''
    networks:
      postfix: {}
    ports:
      # SMTP (Port 25) (Normal)
      - target: 25
        published: 25
        protocol: tcp
        mode: host
      # SMTPS (Port 465) (Implicit TLS)
      - target: 465
        published: 465
        protocol: tcp
        mode: host
      # Submission (Port 587) (STARTTLS)
      - target: 587
        published: 587
        protocol: tcp
        mode: host
    secrets:
      - source: smtp_password
      - source: smtp_username
      - source: smtpd_auth_password
      - source: smtpd_auth_username
    volumes:
      - type: bind
        source: /etc/localtime
        target: /etc/localtime
        read_only: true
      - type: bind
        source: /path/to/your/certs
        target: /etc/postfix/certs
        read_only: true
```

You can start the docker-compose.yml with the following command

```bash
docker compose up -d
```

If you want to see the container logs, you can run

```bash
docker compose logs -f
```

or

```bash
docker logs -f postfix
```

### Google specifics

Gmail by default [does not allow email clients that don't use OAUTH 2](http://googleonlinesecurity.blogspot.co.uk/2014/04/new-security-measures-will-affect-older.html) for authentication (like Thunderbird or Outlook). First you need to enable access to "Less secure apps" on your
[Google settings](https://www.google.com/settings/security/lesssecureapps).

Also take into account that email `From:` header will contain the email address of the account being used to
authenticate against the Gmail SMTP server (SMTP_USERNAME), the one on the email will be ignored by Gmail unless you [add it as an alias](https://support.google.com/mail/answer/22370).

### Debugging

If you need troubleshooting the container you can set the environment variable `DEBUG=yes` for a more verbose output.

---

### Environment Variables

You can set fifteen different environment variables if you want to:

| **Variable** | **Info** | **Value** |
|:----:|:----:|:----:|
|   `SERVER_HOSTNAME`   |   Server hostname for the Postfix container. <br> Emails will appear to come from the hostnames domain.   |   Mandatory, default to `unset`   |
|   `SMTP_SERVER`   |   Server address of the SMTP server to use.   |   Mandatory, default to `unset`  |
|   `SMTP_PORT`   |   Port address of the SMTP server to use.   |   Optional, default value is `587`   |
|   `SMTP_USERNAME`   |   Username to authenticate with to SMTP_SERVER. <br> If `SMTP_USERNAME_FILE` is set, not needed.   |   Optional, default to `unset`   |
|   `SMTP_PASSWORD`   |   Password of the SMTP user. <br> If `SMTP_PASSWORD_FILE` is set, not needed.   |   Mandatory, if `SMTP_USERNAME` is set <br> Default to `unset`   |
|   `SMTP_USERNAME_FILE`   |   Setting this to a mounted file containing the username, to avoid usernames in env variables. <br> Used like `-e SMTP_USERNAME_FILE=/run/secrets/smtp_username`.   |   Optional, default to `unset`   |
|   `SMTP_PASSWORD_FILE`   |   Setting this to a mounted file containing the password, to avoid passwords in env variables. <br> Used like `-e SMTP_PASSWORD_FILE=/run/secrets/smtp_username`.   |   Optional, default to `unset`   |
|   `SMTP_TLS_CA_FILE`   |   Path to a file (PEM) containing trusted CAs for verifying the OUTBOUND server (SMTP_SERVER). <br> Use either `SMTP_TLS_CA_FILE` or `SMTP_TLS_CA_PATH`.   |   Optional, default to `unset`   |
|   `SMTP_TLS_CA_PATH`   |   Path to a directory containing trusted CAs (PEM) for verifying the OUTBOUND server (SMTP_SERVER). <br> Use either `SMTP_TLS_CA_FILE` or `SMTP_TLS_CA_PATH`.   |   Optional, default to `unset`   |
|   `SMTP_NETWORKS`   |   Setting this will allow you to add additional, comma seperated, subnets to use the relay for. <br> Used like `SMTP_NETWORKS='xxx.xxx.xxx.xxx/xx,xxx.xxx.xxx.xxx/xx'`.   |   Optional, default to `unset`   |
|   `SMTPD_AUTH_MODE`   |   Set the security mode for inbound relaying.   |   Optional, default to `mynetworks_only` <br> Can be `mynetworks_only`, `sasl_only`, `ip_or_sasl`, `ip_and_sasl`, `mtls_only` or `ip_and_mtls`   |
|   `SMTPD_AUTH_USERNAME`   |   Username for inbound SASL authentication. <br> Not needed if `SMTPD_AUTH_USERNAME_FILE` is used. <br> Set without FQDN, as DOMAIN is appended automatically from SERVER_HOSTNAME.   |   Optional, default to `unset` <br> Mandatory for SASL modes   |
|   `SMTPD_AUTH_PASSWORD`   |   Password for inbound SASL authentication. <br> Not needed if `SMTPD_AUTH_PASSWORD_FILE` is used.   |   Optional, default to `unset` <br> Mandatory for SASL modes   |
|   `SMTPD_AUTH_USERNAME_FILE`   |   Setting this to a mounted file containing the inbound username, to avoid usernames in env variables. <br> Used like `-e SMTP_USERNAME_FILE=/run/secrets/smtpd_auth_username`. <br> Set without FQDN, as DOMAIN is appended automatically from SERVER_HOSTNAME.   |   Optional, default to `unset`   |
|   `SMTPD_AUTH_PASSWORD_FILE`   |   Setting this to a mounted file containing the inbound password, to avoid passwords in env variables. <br> Used like `-e SMTP_USERNAME_FILE=/run/secrets/smtpd_auth_username`.   |   Optional, default to `unset`   |
|   `SMTPD_AUTH_APPEND_DOMAIN`   |   Set to `no` to create the SASL user without appending the domain (`username` instead of `username@domain.com`).   |   Optional, default to `yes`   |
|   `SMTPD_TLS_ENABLED`   |   Set to `yes` to enable inbound TLS. <br> Port 25 (SMTP, opportunistic STARTTLS), Port 465 (SMTPS, implicit TLS) and Port 587 (Submission, STARTTLS).   |   Optional, default to `no`   |
|   `SMTPD_TLS_FORCED`   |   Set to `yes` to force *global* TLS encryption (smtpd_tls_security_level=encrypt). <br> This will break clients on Port 25 that do not support STARTTLS.   |   Optional, default to `no`   |
|   `SMTPD_TLS_CHAIN_FILE`   |   Path inside the container to your combined TLS chain file. <br> This file MUST contain (in this order): 1. Private Key, 2. Server Certificate, 3. Intermediate CA(s). <br> Can be multiple keys/certs combined in one file.   |   Optional, default to `/etc/postfix/certs/chain.pem` <br> Mandatory if `SMTPD_TLS_ENABLED` is `yes`   |
|   `SMTPD_TLS_CA_FILE`   |   Path to a file containing trusted CAs (PEM format) for verifying client certificates (mTLS). <br> Use either `SMTPD_TLS_CA_FILE` or `SMTPD_TLS_CA_PATH`.   |   Optional, default to `unset` <br> Mandatory for mTLS modes   |
|   `SMTPD_TLS_CA_PATH`   |   Path to a directory containing trusted CAs (PEM format) for verifying client certificates (mTLS). <br> Use either `SMTPD_TLS_CA_FILE` or `SMTPD_TLS_CA_PATH`.   |   Optional, default to `unset` <br> Mandatory for mTLS modes   |
|   `TLS_HARDENING_ENABLED`   |   Set to `yes` to enable modern TLS hardening. <br> force TLSv1.2+, high ciphers, server preference, authentication only over TLS.   |   Optional, default to `no`   |
|   `SMTPD_CLIENT_CONN_RATE_LIMIT`   |   Max connections per minute from the same client.   |   Optional, default to `unset`   |
|   `SMTPD_CLIENT_MSG_RATE_LIMIT`   |   Max messages per minute from the same client.   |   Optional, default to `unset`   |
|   `SMTPD_CLIENT_RCPT_RATE_LIMIT`   |   Max recipients per minute from the same client.   |   Optional, default to `unset`   |
|   `DEBUG`   |   To enable debug logging.   |   Optional, default to `no`   |
|   `SMTP_HEADER_TAG`   |   This will add a header for tracking messages upstream <br> Helpful for spam filters. <br> Will appear as `"RelayTag: ${SMTP_HEADER_TAG}"` in the email headers.   |   Optional, default to `unset`   |
|   `ALWAYS_ADD_MISSING_HEADERS`   |   This is related to the [always\_add\_missing\_headers](http://www.postfix.org/postconf.5.html#always_add_missing_headers) Postfix option. <br> If set to `yes`, Postfix will always add missing headers among `From:`, `To:`, `Date:` or `Message-ID:`.   |   Optional, default to `no`   |
|   `OVERWRITE_FROM`   |   This will rewrite the from address overwriting it with the specified address for all email being relayed. <br> Example settings: <br> OVERWRITE_FROM=<email@company.com> <br> OVERWRITE_FROM="Your Name" <email@company.com>   |   Optional, default to `unset`   |
|   `DESTINATION`   |   This will define a domain for which incoming messages will be accepted. <br> To set a custom `$mydestination` value.   |   Optional, default to `unset`   |
|   `LOG_SUBJECT`   |   This will output the subject line of messages in the log.   |   Optional, default to `unset`   |
|   `SMTPUTF8_ENABLE`   |   Set to `yes` to enable or `no` to disable support for SMTPUTF8. <br> Not setting this variable will use the postfix default, which is `yes`.   |   Optional, default to `unset`   |
|   `MESSAGE_SIZE_LIMIT`   |   This will change the default limit of 10240000 bytes (10MB). <br> This will allow you to set a custom `$message_size_limit` value.   |   Optional, default to `10485760`   |

---

### Build instructions

Clone this repo and then:

```bash
cd docker-Postfix
docker build -t bleala/postfix:dev .
```

Or you can use the provided [docker-compose.yml](https://github.com/Bleala/Postfix-DOCKERIZED/blob/master/docker/docker-compose.override.yml "docker-compose.yml") file:

```bash
docker compose build
```

For more information on using multiple compose files [see here](https://docs.docker.com/compose/production/). You can also find a prebuilt docker image from [Docker Hub](https://hub.docker.com/r/bleala/postfix/ "Docker Hub"), which can be pulled with this command:

```bash
docker pull bleala/postfix:latest
```

---

## Versions

**1.1.0 - 03.11.2025:**

* Inbound TLS (Implicit TLS or STARTTLS) Support
* Possible TLS hardening
* SASL Authentication available
* Allow custom Root CAs
* mTLS Authentication available
* Rate limiting
* Fix smtp_use_tls depecation warning
* Expose port 465 (SMTPS) and 587 (Submission)
* Postfix Version: 3.10.5
* Alpine Version: 3.22.2

**Current Versions:**<br>

* Postfix 3.10.5, Alpine 3.22.2

<details>
<summary>Old Version History</summary><br>

**1.0.4 - 01.09.2025:**

* Dependencies Update
* Postfix Version: 3.10.4
* Alpine Version: 3.22.1

**1.0.3 - 09.01.2025:** Dependencies Update - Postfix 3.9.1, Alpine 3.21.2

**1.0.2 - 21.08.2024:** Dependencies Update - Postfix 3.9.0, Alpine 3.20.2

**1.0.1 - 07.06.2024:** Packages Update - Postfix 3.8.6, Alpine 3.19.1

**1.0.0 - 12.04.2024:** Initial Version - Postfix 3.8.6, Alpine 3.19.1

</details>

---

### Hope you enjoy it! :)

---
