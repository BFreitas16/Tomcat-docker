#!/bin/bash

# Generate signed certificate and stores it at a specific path
# It is possible to pass arguments to manipulate the domain, the 
# subj value associated with the certificate, the path to store all
# files

function print_help() {
  echo "Usage: ./create-ca-certificate.sh [-h] [-c ca_cert] [-k ca_key] [-d domain] [-p path] [-s subj_value]"
}

ca_cert="/certificates/rootCACert.pem"
ca_key="/certificates/rootCAKey.pem"
domain="tomcat.local"
path="/certificates/"
subj_value="/C=PT/ST=Lisbon/L=Lisbon/O=BFreitas16, Inc./OU=IT/CN=${domain}"

# Handle arguments
while getopts c:d:hk:p:s: flag; do
  case "${flag}" in
    c)
      ca_cert="${OPTARG}"
      ;;
    d)
      domain="${OPTARG}"
      ;;
    h)
      print_help
      exit 0
      ;;
    k)
      ca_key="${OPTARG}"
      ;;
    p)
      path="${OPTARG}/"
      ;;
    s)
      subj_value="${OPTARG}"
      ;;
  esac
done

# Make sure the destination folder exists
sudo mkdir -p $path

# Generate RSA private key
sudo openssl genrsa -out "${path}${domain}.pem" 4096

# Generating Certificate Signing Request (CSR)
# Nowadays, browsers do not accept a certificate without a subjectAltName
ext="subjectAltName=DNS:${domain},DNS:*.${domain},IP:127.0.0.1"
sudo openssl req -new -sha256 \
  -key "${path}${domain}.pem" \
  -out "${path}${domain}.csr" \
  -subj "${subj_value}" \
  -addext "${ext}"

# Creating signed Certificate
serial_file=$(echo $ca_cert | sed -E 's/.crt|.pem/.srl/g')
if [ ! -f "${serial_file}" ]; then
  serial_option="-CAcreateserial"
else
  serial_option="-CAserial ${serial_file}"
fi

# Create ext file because for the specific version of openssl, the
# 'copy_extensions' is not working (and without this option, the
# extensions from CSR are not coppied to the X509 certificate)
ext_file="${path}${domain}.ext"
sudo echo "${ext}" > $ext_file

sudo openssl x509 -req -days 3654 $serial_option -sha256 \
  -CA "${ca_cert}" \
  -CAkey "${ca_key}" \
  -in "${path}${domain}.csr" \
  -out "${path}${domain}.crt" \
  -extfile "${ext_file}"

# Configure local DNS
sudo echo "127.0.0.1 ${domain}" >> /etc/hosts
