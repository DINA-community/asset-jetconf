#!/bin/bash

CLIENT_CERT="/home/asset-manager/software/asset-jetconf/utils/cert_gen/analyst@bsi.corp_curl.pem"

POST_DATA="@REPLACE-product.json"

URL="https://127.0.0.1:8443/restconf/operations/jetconf:get-schema-digest"
curl --http2 -k --cert-type PEM -E $CLIENT_CERT -X POST "$URL"


#######################################



