#!/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

echo "--- Replace node attribute"
POST_DATA="@REPLACE-vendor.json"
URL="https://127.0.0.1:8443/restconf/data/ietf-network:networks/network=Inventory1/node=11/asset-inventory-model:device-attributes/vendor"
curl --http2 -k --cert-type PEM -E $CLIENT_CERT -X PUT -d "$POST_DATA" "$URL"

echo "--- conf-commit"
URL="https://127.0.0.1:8443/restconf/operations/jetconf:conf-commit"
curl --http2 -k --cert-type PEM -E $CLIENT_CERT -X POST "$URL"

echo "--- Retrieve network=L31, node=66 from start-up configuration"
URL="https://127.0.0.1:8443/restconf/data/ietf-network:networks/network=Inventory1/node=11"
curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL"


#######################################



