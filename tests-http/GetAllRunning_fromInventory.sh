#!/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

echo "--- Retrieve all inventory from running configuration"
URL="https://127.0.0.1:8443/restconf_running/data/ietf-network:networks/network=Inventory1"
curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL" > Inventory1Running.json
curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL"


#######################################



