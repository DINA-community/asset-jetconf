#!/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

echo "--- Retrieve the server module information"
URL="https://127.0.0.1:8443/restconf/data/ietf-yang-library:modules-state"

curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL" 


#######################################



