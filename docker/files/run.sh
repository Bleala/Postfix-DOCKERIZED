#!/bin/bash

### Docs ###
# https://www.postfix.org/postconf.5.html
# https://www.postfix.org/TLS_README.html
# https://www.postfix.org/SASL_README.html

# shellcheck disable=SC2016,SC2013,SC2001,SC1001 # first needed by postfix, others will be fixed later

# Default to no debug
DEBUG="${DEBUG:-no}"
# Set Debug mode if DEBUG environment variable is set to "yes"
if [[ "${DEBUG}" == "yes" ]]
then
  set -x
fi

# Function for Postfix config value add
add_config_value() {
  # Local variables
  local key="${1}"
  local value="${2}"
  # local config_file=${3:-/etc/postfix/main.cf}

  # If 'key' is empty
  if [[ "${key}" == "" ]] 
  then
    # Error Message
    echo "ERROR: No key set!" 
    exit 1
  fi

  # If 'value' is empty
  if [[ "${value}" == "" ]] 
  then
    # Error Message
    echo "ERROR: No value set!"
    exit 1
  fi

  # Log 'key' with 'value'
  echo "Setting configuration option ${key} with value: ${value}"

  # Set Postfix config
  postconf -e "${key} = ${value}"
}

# Read SMTP_PASSWORD from file to avoid unsecure env variables
if [[ -n "${SMTP_PASSWORD_FILE}" ]]
then
  # Check if 'SMTP_PASSWORD_FILE' exists
  if [[ -e "${SMTP_PASSWORD_FILE}" ]]
  then
    # Set SMTP_PASSWORD variable from file
    SMTP_PASSWORD=$(cat "${SMTP_PASSWORD_FILE}")

  else
    # Log error message, that SMTP_PASSWORD_FILE does not exist
    echo "SMTP_PASSWORD_FILE defined, but file not existing, skipping."
  fi
fi

# Read SMTP_USERNAME from file to avoid unsecure env variables
if [[ -n "${SMTP_USERNAME_FILE}" ]]
then
  # Check if 'SMTP_USERNAME_FILE' exists
  if [[ -e "${SMTP_USERNAME_FILE}" ]]
  then
    # Set SMTP_USERNAME variable from file
    SMTP_USERNAME=$(cat "${SMTP_USERNAME_FILE}")

  else
    # Log error message, that SMTP_USERNAME_FILE does not exist
    echo "SMTP_USERNAME_FILE defined, but file not existing, skipping."
  fi
fi

# Read SMTPD_AUTH_PASSWORD from file to avoid unsecure env variables
if [[ -n "${SMTPD_AUTH_PASSWORD_FILE}" ]]
then
  # Check if 'SMTPD_AUTH_PASSWORD_FILE' exists
  if [[ -e "${SMTPD_AUTH_PASSWORD_FILE}" ]]
  then
    # Set SMTPD_AUTH_PASSWORD variable from file
    SMTPD_AUTH_PASSWORD=$(cat "${SMTPD_AUTH_PASSWORD_FILE}")

  else
    # Log error message, that SMTPD_AUTH_PASSWORD_FILE does not exist
    echo "SMTPD_AUTH_PASSWORD_FILE defined, but file not existing, skipping."
  fi
fi

# Read SMTPD_AUTH_USERNAME from file to avoid unsecure env variables
if [[ -n "${SMTPD_AUTH_USERNAME_FILE}" ]]
then
  # Check if 'SMTPD_AUTH_USERNAME_FILE' exists
  if [[ -e "${SMTPD_AUTH_USERNAME_FILE}" ]]
  then
    # Set SMTPD_AUTH_USERNAME variable from file
    SMTPD_AUTH_USERNAME=$(cat "${SMTPD_AUTH_USERNAME_FILE}")

  else
    # Log error message, that SMTPD_AUTH_USERNAME_FILE does not exist
    echo "SMTPD_AUTH_USERNAME_FILE defined, but file not existing, skipping."
  fi
fi

# Check if SMTP_SERVER variable is empty
if [[ -z "${SMTP_SERVER}" ]]
then
  # Log error message
  echo "SMTP_SERVER is not set"

  # Exit Container
  exit 1
fi

# Check if SERVER_HOSTNAME variable is empty
if [[ -z "${SERVER_HOSTNAME}" ]]
then
  # Log error message
  echo "SERVER_HOSTNAME is not set"

  # Exit Container
  exit 1
fi

# Check if SMTP_USERNAME variable is set, but SMTP_PASSWORD variable is empty
if [[ -n "${SMTP_USERNAME}" ]] && [[ -z "${SMTP_PASSWORD}" ]]
then
  # Log error message
  echo "SMTP_USERNAME is set but SMTP_PASSWORD is not set"

  # Exit Container
  exit 1
fi

# Set SMTP Port, if not set use default value of 587
SMTP_PORT="${SMTP_PORT:-587}"

# Get the domain from the server host name
DOMAIN=$(echo "${SERVER_HOSTNAME}" | awk 'BEGIN{FS=OFS="."}{print $(NF-1),$NF}')

# Set needed config options
add_config_value "maillog_file" "/dev/stdout"
add_config_value "myhostname" "${SERVER_HOSTNAME}"
add_config_value "mydomain" "${DOMAIN}"
add_config_value "mydestination" "${DESTINATION:-localhost}"
add_config_value "myorigin" '$mydomain'
add_config_value "relayhost" "[${SMTP_SERVER}]:${SMTP_PORT}"

# Check if SMTP_USERNAME is set (Outbound Authentication)
if [[ -n "${SMTP_USERNAME}" ]]
then
  add_config_value "smtp_sasl_auth_enable" "yes"
  add_config_value "smtp_sasl_password_maps" "lmdb:/etc/postfix/sasl_passwd"
  add_config_value "smtp_sasl_security_options" "noanonymous"
fi

# Set needed config options
add_config_value "always_add_missing_headers" "${ALWAYS_ADD_MISSING_HEADERS:-no}"

# Also use "native" option to allow looking up hosts added to /etc/hosts via
# docker options (issue #51)
add_config_value "smtp_host_lookup" "dns, native"

# Check if SMTP_PORT is 465 (Outbound TLS)
if [[ "${SMTP_PORT}" = "465" ]]
then
  # Set needed config options for SMTPS (wrapper mode)
  add_config_value "smtp_tls_wrappermode" "yes"
  add_config_value "smtp_tls_security_level" "encrypt"
else
  # Use STARTTLS (opportunistic) for other ports (like 587)
  add_config_value "smtp_tls_security_level" "may"
fi

# Configure Outbound TLS Trust for custom CAs
if [[ -n "${SMTP_TLS_CA_FILE}" ]] && [[ -f "${SMTP_TLS_CA_FILE}" ]]
then
  echo "Configuring smtp_tls_CAfile (for outbound server trust): ${SMTP_TLS_CA_FILE}"
  add_config_value "smtp_tls_CAfile" "${SMTP_TLS_CA_FILE}"
fi

if [[ -n "${SMTP_TLS_CA_PATH}" ]] && [[ -d "${SMTP_TLS_CA_PATH}" ]]
then
  echo "Configuring smtp_tls_CApath (for outbound server trust): ${SMTP_TLS_CA_PATH}"
  add_config_value "smtp_tls_CApath" "${SMTP_TLS_CA_PATH}"
fi

# Bind to both IPv4 and IPv6
add_config_value "inet_protocols" "all"

# https://www.postfix.org/TLS_README.html
# Configure Inbound TLS (SMTPS / STARTTLS)
if [[ "${SMTPD_TLS_ENABLED}" == "yes" ]]
then
  # Log message
  echo "Inbound TLS is ENABLED."

  # Default chain file path
  SMTPD_TLS_CHAIN_FILE="${SMTPD_TLS_CHAIN_FILE:-/etc/postfix/certs/chain.pem}"

  if [[ -f "${SMTPD_TLS_CHAIN_FILE}" ]]
  then
    echo "Found TLS chain file. Configuring Postfix for inbound TLS."
    
    # This file should contain: Private Key, THEN Server Certificate, THEN Intermediate CAs (fullchain)
    # Mutliple Key/Cert pairs are supported
    add_config_value "smtpd_tls_chain_files" "${SMTPD_TLS_CHAIN_FILE}"

    # Default to "no" if not set
    SMTPD_TLS_FORCED="${SMTPD_TLS_FORCED:-no}"
    # Set global inbound TLS security level
    if [[ "${SMTPD_TLS_FORCED}" == "yes" ]]
    then
      echo "Forcing global TLS (encrypt) on all inbound ports."
      add_config_value "smtpd_tls_security_level" "encrypt"
    else
      echo "Using opportunistic TLS (may) on port 25."
      add_config_value "smtpd_tls_security_level" "may"
    fi

    # Set Logging level to 1
    add_config_value "smtpd_tls_loglevel" "1"
    
    # Enable SMTPS (port 465, wrapper mode) listener in master.cf
    # This overrides the global smtpd_tls_security_level
    echo "Enabling SMTPS (port 465) listener."
    postconf -M smtps/inet="smtps inet n - - - - smtpd"
    postconf -P smtps/inet/smtpd_tls_wrappermode=yes
    
    # Enable Submission (port 587) listener in master.cf
    # This overrides the global smtpd_tls_security_level
    echo "Enabling Submission (port 587) listener."
    postconf -M submission/inet="submission inet n - - - - smtpd"
    postconf -P submission/inet/smtpd_tls_security_level=encrypt

    # Check if CA files for mTLS are provided
    if [[ (-n "${SMTPD_TLS_CA_FILE}" && -f "${SMTPD_TLS_CA_FILE}") || (-n "${SMTPD_TLS_CA_PATH}" && -d "${SMTPD_TLS_CA_PATH}") ]]
    then
      echo "Inbound mTLS is ENABLED."

      # Add CA file for client certificate verification (mTLS)
      if [[ -n "${SMTPD_TLS_CA_FILE}" ]] && [[ -f "${SMTPD_TLS_CA_FILE}" ]]
      then
        echo "Configuring smtpd_tls_CAfile (for client cert trust): ${SMTPD_TLS_CA_FILE}"
        add_config_value "smtpd_tls_CAfile" "${SMTPD_TLS_CA_FILE}"
      fi

      # Add CA path for client certificate verification (mTLS)
      # Note: The user is responsible for running c_rehash on this directory if needed.
      # https://www.postfix.org/postconf.5.html#smtpd_tls_CApath
      if [[ -n "${SMTPD_TLS_CA_PATH}" ]] && [[ -d "${SMTPD_TLS_CA_PATH}" ]]
      then
        echo "Configuring smtpd_tls_CApath (for client cert trust): ${SMTPD_TLS_CA_PATH}"
        add_config_value "smtpd_tls_CApath" "${SMTPD_TLS_CA_PATH}"
      fi

      echo "mTLS CA file(s) found. Requesting client certificates."
      add_config_value "smtpd_tls_ask_ccert" "yes"
      # Explicitly disable appending default system CAs
      # This ensures only specified CAs are used for mTLS
      add_config_value "tls_append_default_CA" "no"

    else
      echo "Inbound mTLS is DISABLED."
      echo "No mTLS CA file(s) provided. Client certificates will not be requested."
      add_config_value "smtpd_tls_ask_ccert" "no"

      # If mTLS modes are selected without a CA, they will fail.
      if [[ "${SMTPD_AUTH_MODE}" =~ mtls ]]
      then
        echo "ERROR: SMTPD_AUTH_MODE=${SMTPD_AUTH_MODE} requires SMTPD_TLS_CA_FILE or SMTPD_TLS_CA_PATH to be set."
        echo "Container will exit."
        exit 1
      fi
    fi

  else
    # Warning message
    echo "WARNING: SMTPD_TLS_ENABLED=yes but the chain file is not found. Inbound TLS has been disabled."
    echo "Chain file: ${SMTPD_TLS_CHAIN_FILE}"
  fi
else
  echo "Inbound TLS is DISABLED."
fi

# Configure Relay Restrictions (mynetworks)
# This logic runs always. Auth logic below will decide HOW it will be used.
echo "Configuring mynetworks (trusted IPs)."
# Only allow localhost. User must add their nets via SMTP_NETWORKS.
nets='127.0.0.1/32, [::1]/128'

# Add user-defined networks from SMTP_NETWORKS env variable
if [[ -n "${SMTP_NETWORKS}" ]]
then
  declare ipv6re="^((([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|\
    ([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|\
    ([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|\
    ([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|\
    :((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}|\
    ::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|\
    (2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|\
    (2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))/[0-9]{1,3})$"

  for i in $(sed 's/,/\ /g' <<< "${SMTP_NETWORKS}")
  do
    if grep -Eq "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}" <<< "${i}"
    then
      nets+=", ${i}"
    elif grep -Eq "${ipv6re}" <<< "${i}"
    then
      readarray -d \/ -t arr < <(printf '%s' "${i}")
      nets+=", [${arr[0]}]/${arr[1]}"
    else
      echo "${i} is not in proper IPv4 or IPv6 subnet format. Ignoring."
    fi
  done
fi
add_config_value "mynetworks" "${nets}"


# Configure Inbound SASL Authentication & Relay Restrictions

# Default to 'mynetworks_only' if not set
SMTPD_AUTH_MODE="${SMTPD_AUTH_MODE:-mynetworks_only}"

# Configure SASL if mode requires it AND credentials are provided
if [[ "${SMTPD_AUTH_MODE}" =~ sasl ]]
then
  echo "Inbound SASL Authentication is ENABLED."
  if [[ -n "${SMTPD_AUTH_USERNAME}" ]] && [[ -n "${SMTPD_AUTH_PASSWORD}" ]]
  then
    
    echo "Inbound SASL Authentication is being configured."
    # Configure sasldb
    echo "Configuring sasldb."
    # Ensure the /etc/sasl2 directory exists before writing to it
    mkdir -p /etc/sasl2

    # https://www.postfix.org/SASL_README.html
    # Create /etc/sasl2/smtpd.conf file
    {
      echo "pwcheck_method: auxprop"
      echo "auxprop_plugin: sasldb"
      echo "mech_list: PLAIN LOGIN CRAM-MD5"
      echo "sasldb_path: /etc/postfix/sasldb2"
    } > /etc/sasl2/smtpd.conf
    
    # Create user in sasldb
    # Clients will need to authenticate as 'username@domain'
    echo "Creating SASL user \"${SMTPD_AUTH_USERNAME}@${DOMAIN}\"."
    echo "${SMTPD_AUTH_PASSWORD}" | saslpasswd2 -c -p -u "${DOMAIN}" -f /etc/postfix/sasldb2 "${SMTPD_AUTH_USERNAME}"
    
    # Verify that sasldb2 file was created
    if [[ -f /etc/postfix/sasldb2 ]]
    then
      echo "SASL database created."
      # Fix permissions: Set owner to root:postfix to avoid "not owned by root" warning
      chown root:root /etc/postfix/sasldb2
      chmod 644 /etc/postfix/sasldb2
    
      # Configure Postfix main.cf for SASL
      add_config_value "smtpd_sasl_auth_enable" "yes"
      add_config_value "smtpd_sasl_security_options" "noanonymous"
      add_config_value "smtpd_sasl_local_domain" "\$myhostname"
      # Explicitly tell Postfix where to find the SASL config
      add_config_value "cyrus_sasl_config_path" "/etc/sasl2"

      # Configure master.cf listeners for SASL
      postconf -P "*/inet/smtpd_sasl_auth_enable=yes"
      echo "SASL configuration complete."

    else
      echo "ERROR: Failed to create sasldb file at /etc/postfix/sasldb2."
      echo "Container will exit."
      exit 1
    fi
    
  else
    echo "WARNING: SMTPD_AUTH_MODE set to '${SMTPD_AUTH_MODE}' but SMTPD_AUTH_USERNAME or SMTPD_AUTH_PASSWORD is not set."
    echo "Falling back to 'mynetworks_only' mode."
    SMTPD_AUTH_MODE="mynetworks_only"
  fi
fi

# Set Relay Restrictions based on final mode
echo "Setting relay restrictions for mode: ${SMTPD_AUTH_MODE}"
# Determine relay restrictions based on SMTPD_AUTH_MODE
case "${SMTPD_AUTH_MODE}" in
    "sasl_only")
        # Mode 1: Only SASL authenticated users can relay. IP does not matter.
        echo "Mode: SASL_ONLY. Only authenticated clients can relay."
        add_config_value "smtpd_client_restrictions" "permit"
        add_config_value "smtpd_recipient_restrictions" "permit_sasl_authenticated, reject_unauth_destination"
        ;;

    "ip_or_sasl")
        # Mode 2: Flexible (OR). Clients from mynetworks OR SASL authenticated users can relay.
        echo "Mode: IP_OR_SASL. Authenticated clients or clients in mynetworks can relay."
        add_config_value "smtpd_client_restrictions" "permit"
        add_config_value "smtpd_recipient_restrictions" "permit_sasl_authenticated, permit_mynetworks, reject_unauth_destination"
        ;;

    "ip_and_sasl")
        # Mode 3: Strict (AND). Clients must be from mynetworks AND be SASL authenticated.
        echo "Mode: IP_AND_SASL. Only authenticated clients in mynetworks can relay."
        add_config_value "smtpd_client_restrictions" "permit_mynetworks, reject"
        add_config_value "smtpd_recipient_restrictions" "permit_sasl_authenticated, reject_unauth_destination"
        ;;

    "mtls_only")
        # Mode 5: High Security. Only clients presenting a valid certificate trusted by our CA can relay.
        echo "Mode: MTLS_ONLY. Only clients with valid, trusted certificates can relay."
        # Check if CA files are actually provided for this mode
        if [[ -z "${SMTPD_TLS_CA_FILE}" ]] && [[ -z "${SMTPD_TLS_CA_PATH}" ]]
        then
          echo "ERROR: SMTPD_AUTH_MODE=mtls_only, but no SMTPD_TLS_CA_FILE or SMTPD_TLS_CA_PATH is set."
          echo "Cannot enforce mTLS without a trusted CA. Exiting."
          exit 1
        fi
        
        # Require a trusted certificate on all encrypted ports (465, 587)
        # This will be ignored on port 25 (where smtpd_tls_security_level=may) if SMTPD_TLS_FORCED=no
        add_config_value "smtpd_tls_req_ccert" "yes"
        
        # Client must connect, then present cert.
        add_config_value "smtpd_client_restrictions" "permit"
        add_config_value "smtpd_recipient_restrictions" "permit_tls_all_clientcerts, reject_unauth_destination"
        
        # Ensure SASL is off
        add_config_value "smtpd_sasl_auth_enable" "no"
        postconf -P "*/inet/smtpd_sasl_auth_enable=no"
        ;;

    "ip_and_mtls")
        # Mode 6: Highest Security (AND). Clients must be from mynetworks AND have a valid mTLS certificate.
        echo "Mode: IP_AND_MTLS. Only clients from mynetworks AND with a valid certificate can relay."
        # Check if CA files are actually provided for this mode
        if [[ -z "${SMTPD_TLS_CA_FILE}" ]] && [[ -z "${SMTPD_TLS_CA_PATH}" ]]
        then
          echo "ERROR: SMTPD_AUTH_MODE=ip_and_mtls, but neiter SMTPD_TLS_CA_FILE nor SMTPD_TLS_CA_PATH is set."
          echo "Cannot enforce mTLS without a trusted CA. Exiting."
          exit 1
        fi
        
        # Require a trusted certificate on all encrypted ports (465, 587)
        # This will be ignored on port 25 (where smtpd_tls_security_level=may) if SMTPD_TLS_FORCED=no
        add_config_value "smtpd_tls_req_ccert" "yes"
        
        # Client must be in mynetworks, then present cert.
        add_config_value "smtpd_client_restrictions" "permit_mynetworks, reject"
        add_config_value "smtpd_recipient_restrictions" "permit_tls_all_clientcerts, reject_unauth_destination"
        
        # Ensure SASL is off
        add_config_value "smtpd_sasl_auth_enable" "no"
        postconf -P "*/inet/smtpd_sasl_auth_enable=no"
        ;;

    *) # "mynetworks_only"
        # Mode 4: Default. Only clients from mynetworks can relay. SASL is disabled.
        echo "Mode: MYNETWORKS_ONLY. Only clients in mynetworks can relay."
        # Reject clients not in mynetworks immediately at connect time.
        add_config_value "smtpd_client_restrictions" "permit_mynetworks, reject"
        add_config_value "smtpd_recipient_restrictions" "reject_unauth_destination"

        # Ensure SASL is off
        add_config_value "smtpd_sasl_auth_enable" "no"
        postconf -P "*/inet/smtpd_sasl_auth_enable=no"
        ;;
esac

# Create sasl_passwd file with auth credentials (Outbound Auth)
if [[ ! -f /etc/postfix/sasl_passwd ]] && [[ -n "${SMTP_USERNAME}" ]]
then
  if ! grep -q "${SMTP_SERVER}" /etc/postfix/sasl_passwd > /dev/null 2>&1
  then
    echo "Adding SASL authentication configuration"
    echo "[${SMTP_SERVER}]:${SMTP_PORT} ${SMTP_USERNAME}:${SMTP_PASSWORD}" >> /etc/postfix/sasl_passwd
    postmap /etc/postfix/sasl_passwd
  fi
fi

# Set header tag
if [[ -n "${SMTP_HEADER_TAG}" ]]
then
  add_config_value "header_checks" "regexp:/etc/postfix/header_checks"
  echo -e "/^MIME-Version:/i PREPEND RelayTag: $SMTP_HEADER_TAG\n/^Content-Transfer-Encoding:/i PREPEND RelayTag: $SMTP_HEADER_TAG" >> /etc/postfix/header_checks
  echo "Setting configuration option SMTP_HEADER_TAG with value: ${SMTP_HEADER_TAG}"
fi

# Enable logging of subject line
if [[ "${LOG_SUBJECT}" == "yes" ]]
then
  add_config_value "header_checks" "regexp:/etc/postfix/header_checks"
  echo -e "/^Subject:/ WARN" >> /etc/postfix/header_checks
  echo "Enabling logging of subject line"
fi

# Default to yes SMTPUTF8 support if not set
SMTPUTF8_ENABLE="${SMTPUTF8_ENABLE:-yes}"
# Set SMTPUTF8
if [[ "${SMTPUTF8_ENABLE}" == "yes" ]]
then
  add_config_value "smtputf8_enable" "${SMTPUTF8_ENABLE}"
  echo "Setting configuration option smtputf8_enable with value: ${SMTPUTF8_ENABLE}"
else
  add_config_value "smtputf8_enable" "no"
  echo "Setting configuration option smtputf8_enable with value: no"
fi

# Overwrite From header
if [[ -n "${OVERWRITE_FROM}" ]]
then
  echo -e "/^From:.*$/ REPLACE From: ${OVERWRITE_FROM}" > /etc/postfix/smtp_header_checks
  postmap /etc/postfix/smtp_header_checks
  add_config_value "smtp_header_checks" "regexp:/etc/postfix/smtp_header_checks"
  echo "Setting configuration option OVERWRITE_FROM with value: ${OVERWRITE_FROM}"
fi

# Default MESSAGE_SIZE_LIMIT to 10485760 (10MB) if not set
MESSAGE_SIZE_LIMIT="${MESSAGE_SIZE_LIMIT:-10485760}"
# Set message_size_limit
if [[ -n "${MESSAGE_SIZE_LIMIT}" ]]
then
  add_config_value "message_size_limit" "${MESSAGE_SIZE_LIMIT}"
  echo "Setting configuration option message_size_limit with value: ${MESSAGE_SIZE_LIMIT}"
fi

# Configure Rate Limiting (Anvil)
# Check if any rate limit is set
if [[ -n "${SMTPD_CLIENT_CONN_RATE_LIMIT}" ]] || \
   [[ -n "${SMTPD_CLIENT_MSG_RATE_LIMIT}" ]] || \
   [[ -n "${SMTPD_CLIENT_RCPT_RATE_LIMIT}" ]]
then
  # Log message
  echo "Client rate limiting is ENABLED."

  echo "Configuring client rate limits (anvil)."
  # Set the time unit for all limits (e.g., 60s = per minute)
  add_config_value "anvil_rate_time_unit" "60s"

  # Set client connection rate limit
  if [[ -n "${SMTPD_CLIENT_CONN_RATE_LIMIT}" ]]
  then
    add_config_value "smtpd_client_connection_rate_limit" "${SMTPD_CLIENT_CONN_RATE_LIMIT}"
  fi
  
  # Set client message rate limit
  if [[ -n "${SMTPD_CLIENT_MSG_RATE_LIMIT}" ]]
  then
    add_config_value "smtpd_client_message_rate_limit" "${SMTPD_CLIENT_MSG_RATE_LIMIT}"
  fi
  
  # Set client recipient rate limit
  if [[ -n "${SMTPD_CLIENT_RCPT_RATE_LIMIT}" ]]
  then
    add_config_value "smtpd_client_recipient_rate_limit" "${SMTPD_CLIENT_RCPT_RATE_LIMIT}"
  fi
  
else
  # No rate limits set
  echo "Client rate limiting is DISABLED."
fi

# Default TLS Hardening to "no" if not set
TLS_HARDENING_ENABLED="${TLS_HARDENING_ENABLED:-no}"
# Configure TLS Hardening
if [[ "${TLS_HARDENING_ENABLED}" == "yes" ]]
then
  echo "TLS Hardening is ENABLED."
  
  # Force TLSv1.2+ for inbound and outbound
  echo "Setting minimum TLS version to TLSv1.2."
  add_config_value "smtpd_tls_protocols" ">=TLSv1.2, <=TLSv1.3"
  add_config_value "smtp_tls_protocols" ">=TLSv1.2, <=TLSv1.3"
  add_config_value "smtpd_tls_mandatory_protocols" ">=TLSv1.2, <=TLSv1.3"
  add_config_value "smtp_tls_mandatory_protocols" ">=TLSv1.2, <=TLSv1.3"
  
  # Use 'high' cipher grade
  echo "Setting cipher grade to 'high'."
  add_config_value "smtpd_tls_mandatory_ciphers" "high"
  add_config_value "smtp_tls_mandatory_ciphers" "high"
  
  # Force server's cipher preference
  echo "Enforcing servers cipher preference."
  add_config_value "tls_preempt_cipherlist" "yes"

  # Enforce Auth only over TLS (if SASL is enabled)
  if [[ "${SMTPD_AUTH_MODE}" =~ sasl ]]
  then
  echo "Enforcing authentication only over TLS."
  add_config_value "smtpd_tls_auth_only" "yes"
  fi

else
  echo "TLS Hardening is DISABLED. Using Postfix/OpenSSL defaults."
fi

# If host mounting /var/spool/postfix, we need to delete old pid file before
# starting services
rm -f /var/spool/postfix/pid/master.pid

echo "Starting Postfix."
# Start Postfix service
exec /usr/sbin/postfix -c /etc/postfix start-fg
