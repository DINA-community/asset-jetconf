#!/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

echo "--- Retrieve all asset information from running configuration"
URL="https://127.0.0.1:8443/restconf_running/data/ietf-network:networks/network=Inventory1"
curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL" | jq '."ietf-network:network"' | jq '.[]' | jq '."node"' | jq '.[]' | jq '{ ID: ."node-id", MAC_ADDR: ."asset-inventory-model:device-attributes"."mac-addresses", IP_SERVICES: ."asset-inventory-model:device-attributes"."ipv4-services", FINDINGS: ."asset-inventory-model:device-attributes"."findings"}' > AssetAllRunning.json

curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL" | jq '."ietf-network:network"' | jq '.[]' | jq '."node"' | jq '.[]' | jq '{ ID: ."node-id", MAC_ADDR: ."asset-inventory-model:device-attributes"."mac-addresses", IP_SERVICES: ."asset-inventory-model:device-attributes"."ipv4-services", FINDINGS: ."asset-inventory-model:device-attributes"."findings"}'

#######################################



