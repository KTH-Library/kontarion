#!/bin/bash
set -e

curl -sL -o /tmp/certificate.crt "https://static.sys.kth.se/public/certificates/certificate.ug.kth.se.public.cer"
#openssl x509 -inform PEM -in /tmp/certificate.cert -out certificate.crt
cp /tmp/certificate.crt /usr/local/share/ca-certificates
rm /tmp/certificate.crt

update-ca-certificates

