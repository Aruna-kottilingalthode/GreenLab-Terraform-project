#!/bin/bash
set -e

# Variables passed from Terraform
ad_domain="${ad_domain}"        # example: lab.local
ad_realm="${ad_realm}"          # example: lab.local in uppercase if needed
ad_dc_ip="${ad_dc_ip}"     # DC private IP
secret_arn="${secret_arn}"
region="${region}"

export DEBIAN_FRONTEND=noninteractive

# Update packages and install tools
apt update -y
apt install -y jq realmd sssd-ad sssd-tools sssd libnss-sss libpam-sss adcli samba-common-bin krb5-user packagekit systemd-resolved

# Disable systemd-resolved overwriting DNS
systemctl stop systemd-resolved
systemctl disable systemd-resolved
rm -f /etc/resolv.conf

# Configure DNS to use AD Domain Controller
cat <<EOF >/etc/resolv.conf
nameserver ${ad_dc_ip}
search ${ad_domain}
EOF

echo "DNS set to AD DC ${ad_dc_ip}"

# Retrieve AD admin password from Secrets Manager
ad_password=$(aws secretsmanager get-secret-value \
    --secret-id "$secret_arn" \
    --region "$region" \
    --query SecretString \
    --output text)

# Configure Kerberos
cat <<EOF >/etc/krb5.conf
[libdefaults]
    default_realm = ${ad_realm}
    dns_lookup_realm = true
    dns_lookup_kdc = true
    rdns = false
    ticket_lifetime = 24h

[realms]
${ad_realm} = {
    kdc = ${ad_dc_ip}
    admin_server = ${ad_dc_ip}
}

[domain_realm]
.${ad_domain} = ${ad_realm}
${ad_domain} = ${ad_realm}
EOF

echo "Kerberos configuration complete."

# Test Kerberos
echo "$${ad_password}" | kinit administrator@${ad_realm}

# Join AD domain
echo "$${ad_password}" | realm join ${ad_domain} -U "administrator" --verbose

# Enable home directory creation for AD users
pam-auth-update --enable mkhomedir

# Configure SSSD
cat <<EOF >/etc/sssd/sssd.conf
[sssd]
services = nss, pam
config_file_version = 2
domains = ${ad_domain}

[domain/${ad_domain}]
ad_domain = ${ad_domain}
krb5_realm = ${ad_realm}
realmd_tags = manages-system joined-with-adcli
cache_credentials = True
id_provider = ad
use_fully_qualified_names = False
fallback_homedir = /home/%u
default_shell = /bin/bash
ldap_id_mapping = True
EOF

chmod 600 /etc/sssd/sssd.conf
systemctl enable --now sssd

echo "Ubuntu Jumpbox initialization and AD join completed successfully."

