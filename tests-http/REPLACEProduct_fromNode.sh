#!/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

echo "--- Replace product attribute"
POST_DATA="@REPLACE-product.json"

URL="https://127.0.0.1:8443/restconf/data/ietf-network:networks/network=Inventory1/node=$1/asset-inventory-model:device-attributes/product"
curl --http2 -k --cert-type PEM -E $CLIENT_CERT -X PUT -d "$POST_DATA" "$URL"

echo "--- before commit"
./GetAllCandidate_fromNode.sh $1
./GetAllRunning_fromNode.sh $1

echo "--- conf-commit the candidate configuration"
#URL="https://127.0.0.1:8443/restconf/operations/jetconf:conf-commit"
#curl --http2 -k --cert-type PEM -E $CLIENT_CERT -X POST "$URL"
./CommitCandidate.sh 

echo "--- after commit"
#URL="https://127.0.0.1:8443/restconf/data/ietf-network:networks/network=Inventory1/node=$1"
#curl --http2 -k --cert-type PEM -E $CLIENT_CERT "$URL"
./GetAllRunning_fromNode.sh $1

#######################################



