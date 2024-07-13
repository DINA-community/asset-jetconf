#!/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

echo "--- Retrieve the RESTCONF Root  Resource"
URL="https://127.0.0.1:8443/.well-known/host-meta"

curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL" 


#######################################



