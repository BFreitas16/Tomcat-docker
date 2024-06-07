#!/bin/bash

# Generate a self-signed CA certificate and stores it at a specific path
# It is possible to pass arguments to manipulate the certificate and key
# names, the path to store all files and the subj value associated with
# the certificate

function print_help() {
  echo "Usage: ./create-ca-certificate.sh [-h] [-c cert_name] [-k key_name] [-p path] [-s subj_value]"
}

cert_name="rootCACert"
key_name="rootCAKey"
path="/certificates/"
subj_value="/C=PT/ST=Lisbon/L=Lisbon/O=BFreitas16, Inc./OU=IT/CN=bfreitas.local"

# Handle arguments
while getopts c:hk:p:s: flag; do
  case "${flag}" in
    c)
      cert_name="${OPTARG}"
      ;;
    h)
      print_help
      exit 0
      ;;
    k)
      key_name="${OPTARG}"
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
mkdir -p $path

# Generate RSA private key
sudo openssl genrsa -out "${path}${key_name}.pem" 4096

# Generate self-signed CA certificate
sudo openssl req -x509 -new -nodes -days 3654 -sha256 \
  -key "${path}${key_name}.pem" \
  -out "${path}${cert_name}.pem" \
  -subj "${subj_value}"

# Install the newly created CA certificate
sudo cp "${path}${cert_name}.pem" "/usr/local/share/ca-certificates/${cert_name}.crt"
sudo update-ca-certificates
