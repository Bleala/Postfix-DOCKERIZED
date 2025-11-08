# [Postfix](https://www.postfix.org/documentation.html "Official Documentation")-DOCKERIZED

[![GitHub Release](https://img.shields.io/github/v/release/Bleala/Postfix-DOCKERIZED?style=flat-square&label=Version)](https://github.com/Bleala/Postfix-DOCKERIZED/releases)
[![Docker Stars](https://img.shields.io/docker/stars/bleala/postfix?style=flat-square&label=Docker%20Stars)](https://hub.docker.com/r/bleala/postfix/)
[![Docker Pulls](https://img.shields.io/docker/pulls/bleala/postfix?style=flat-square&label=Docker%20Pulls)](https://hub.docker.com/r/bleala/postfix/)
[![Container Build Check 🐳✅](https://github.com/Bleala/Postfix-DOCKERIZED/actions/workflows/container-build-check.yaml/badge.svg)](https://github.com/Bleala/Postfix-DOCKERIZED/actions/workflows/container-build-check.yaml)

A simple [Postfix](https://www.postfix.org/ "Postfix Homepage") SMTP TLS relay docker [Alpine Linux](https://hub.docker.com/_/alpine "Alpine Linux Image") based image with no local authentication enabled (to be run in a secure LAN).

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

```docker compose.yml
---
version: "3.9"

networks:
  postfix:
    name: postfix
    driver: bridge

secrets:
  smtp_password:
    file: /path/to/your/secret/file/smtp_password

services:
  # Postfix SMTP Relay - Simple Postfix SMTP TLS relay docker alpine based image with no local authentication enabled (to be run in a secure LAN).
  # https://hub.docker.com/r/bleala/postfix
  # https://github.com/Bleala/Postfix-DOCKERIZED
  postfix:
    image: bleala/postfix:latest
    container_name: postfix
    hostname: postfix
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    environment:
      # Mandatory: Server address of the SMTP server to use.
      SMTP_SERVER: ''
      # Optional: (Default value: 587) Port address of the SMTP server to use.
      SMTP_PORT: ''
      # Optional: Username to authenticate with.
      SMTP_USERNAME: ''
      # Optional (Mandatory if SMTP_USERNAME is set): Password of the SMTP user. (Not needed if SMTP_PASSWORD_FILE is used)
      SMTP_PASSWORD: ''
      # Mandatory: Server hostname for the Postfix container. Emails will appear to come from the hostname's domain.
      SERVER_HOSTNAME: ''
      # Optional: This will add a header for tracking messages upstream. Helpful for spam filters. Will appear as "RelayTag: ${SMTP_HEADER_TAG}" in the email headers.
      SMTP_HEADER_TAG: ''
      # Optional: Setting this will allow you to add additional, comma seperated, subnets to use the relay. Used like SMTP_NETWORKS='xxx.xxx.xxx.xxx/xx,xxx.xxx.xxx.xxx/xx'.
      SMTP_NETWORKS: ''
      # Optional: Set this to a mounted file containing the password, to avoid passwords in env variables.
      SMTP_PASSWORD_FILE: ''
      # Optional: Set this to yes to always add missing From:, To:, Date: or Message-ID: headers.
      ALWAYS_ADD_MISSING_HEADERS: 'yes'
      # Optional: This will rewrite the from address overwriting it with the specified address for all email being relayed.
      OVERWRITE_FROM: "Your Name <email@company.com>"
      # Optional: This will use allow you to set a custom $mydestination value. Default is localhost.
      DESTINATION: ''
      # Optional: This will output the subject line of messages in the log.
      LOG_SUBJECT: 'yes'
      # Optional: This will disable (no) or enable (yes) the use of SMTPUTF8
      SMTPUTF8_ENABLE: 'no'
      # Optional: This will use allow you to set a custom $message_size_limit value. Default is 10240000.
      MESSAGE_SIZE_LIMIT: ''
    env_file:
      - .env
    networks:
      postfix: {}
    ports:
      - target: 25
        published: 25
        protocol: tcp
        mode: host
    secrets:
      - smtp_password
    volumes:
      - type: bind
        source: /etc/localtime
        target: /etc/localtime
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
[google settings](https://www.google.com/settings/security/lesssecureapps).

Also take into account that email `From:` header will contain the email address of the account being used to
authenticate against the Gmail SMTP server (SMTP_USERNAME), the one on the email will be ignored by Gmail unless you [add it as an alias](https://support.google.com/mail/answer/22370).

### Debugging

If you need troubleshooting the container you can set the environment variable `DEBUG=yes` for a more verbose output.

---

### Environment Variables

You can set fifteen different environment variables if you want to:

| **Variable** | **Info** | **Value** |
|:----:|:----:|:----:|
|   `SMTP_SERVER`   |   Server address of the SMTP server to use   |   Mandatory, default to `unset`  |
|   `SERVER_HOSTNAME`   |   Server hostname for the Postfix container <br> Emails will appear to come from the hostname's domain   |   Mandatory, default to `unset`   |
|   `SMTP_PORT`   |   Port address of the SMTP server to use   |   Optional, default value is `587`   |
|   `SMTP_USERNAME`   |   Username to authenticate with   |   Optional, default to `unset`   |
|   `SMTP_PASSWORD`   |   Password of the SMTP user <br> If `SMTP_PASSWORD_FILE` is set, not needed   |   Mandatory, if `SMTP_USERNAME` is set <br> Default to `unset`   |
|   `SMTP_HEADER_TAG`   |   This will add a header for tracking messages upstream <br> Helpful for spam filters <br> Will appear as "RelayTag: ${SMTP_HEADER_TAG}" in the email headers   |   Optional, default to `unset`   |
|   `SMTP_NETWORKS`   |   Setting this will allow you to add additional, comma seperated, subnets to use the relay <br> Used like `-e SMTP_NETWORKS='xxx.xxx.xxx.xxx/xx,xxx.xxx.xxx.xxx/xx'`   |   Optional, default to `unset`   |
|   `SMTP_USERNAME_FILE`   |   Setting this to a mounted file containing the username, to avoid usernames in env variables <br> Used like `-e SMTP_USERNAME_FILE=/secrets/smtp_username`   |   Optional, default to `unset`   |
|   `SMTP_PASSWORD_FILE`   |   Setting this to a mounted file containing the username, to avoid usernames in env variables <br> Used like `-e SMTP_PASSWORD_FILE=/secrets/smtp_username`   |   Optional, default to `unset`   |
|   `ALWAYS_ADD_MISSING_HEADERS`   |   This is related to the [always\_add\_missing\_headers](http://www.postfix.org/postconf.5.html#always_add_missing_headers) Postfix option <br> If set to `yes`, Postfix will always add missing headers among `From:`, `To:`, `Date:` or `Message-ID:`   |   Optional, default to `no`   |
|   `OVERWRITE_FROM`   |   This will rewrite the from address overwriting it with the specified address for all email being relayed <br> Example settings: <br> OVERWRITE_FROM=<email@company.com> <br> OVERWRITE_FROM="Your Name" <email@company.com>   |   Optional, default to `unset`   |
|   `DESTINATION`   |   This will define a list of domains from which incoming messages will be accepted   |   Optional, default to `unset`   |
|   `LOG_SUBJECT`   |   This will output the subject line of messages in the log   |   Optional, default to `no`   |
|   `SMTPUTF8_ENABLE`   |   This will enable or disable support for SMTPUTF8 <br> Valid values are `no` to disable and `yes` to enable <br> Not setting this variable will use the postfix default, which is `yes`.   |   Optional, default to `yes`   |
|   `MESSAGE_SIZE_LIMIT`   |   This will change the default limit of 10240000 bytes (10MB)   |   Optional, default to `10240000`   |

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

**1.0.4 - 01.09.2025:**

* Dependencies Update
* Postfix Version: 3.10.4
* Alpine Version: 3.22.1

**Current Versions:**<br>

* Postfix 3.10.4, Alpine 3.22.1

<details>
<summary>Old Version History</summary><br>

**1.0.3 - 09.01.2025:** Dependencies Update - Postfix 3.9.1, Alpine 3.21.2

**1.0.2 - 21.08.2024:** Dependencies Update - Postfix 3.9.0, Alpine 3.20.2

**1.0.1 - 07.06.2024:** Packages Update - Postfix 3.8.6, Alpine 3.19.1

**1.0.0 - 12.04.2024:** Initial Version - Postfix 3.8.6, Alpine 3.19.1

</details>

---

### Hope you enjoy it! :)

---
