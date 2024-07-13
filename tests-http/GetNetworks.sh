#!/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

echo "--- Retrieve network information from running configuration"
URL="https://127.0.0.1:8443/restconf_running/data/ietf-network:networks/"

curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL" |  jq '."ietf-network:networks"'| jq '."network"'| jq '.[]' | jq '."network-types"'

#######################################



