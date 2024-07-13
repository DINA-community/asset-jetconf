#!/usr/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

echo "--- Retrieve all inventory data from candidate configuration"
URL="https://127.0.0.1:8443/restconf/data/ietf-network:networks/network=Inventory1?depth=3"

curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL" 


#######################################



