#!/bin/bash
#
#####################################################
#
#  Projekt: BSI-507
#  Asset-jetconf backend installation
#  file: install.bash
#
#####################################################
#
#  Jörg Kippe
#  Fraunhofer IOSB
#  Fraunhoferstr. 1
#  D-76131 Karlsruhe
#
#####################################################

# Abort for errors
set -euo pipefail
# debug mode
[ -z "${DEBUG-}" ] || set -x

echo "Installing starting..."

#checking for root rights
if [ $EUID != 0 ]; then
  echo -e '"Not enough minerals!" - Are you root? '
  exit 1
fi

apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get -y install libyang-tools git python3-pip python3-setuptools-scm

git config user.email "root@assetmanager.bsi.corp"

python3 -m pip install --break-system-packages jetconf pyang
python3 -m pip install --break-system-packages -e .

pushd utils/cert_gen
#./gen_server_cert.sh assetmgt 172.16.15.1.82
#./gen_client_cert.sh joerg@iosb.fraunhofer.de
./gen_server_cert.sh assetmgt bsi.corp
./gen_client_cert.sh analyst@bsi.corp
popd

##cp ca.pem /home/analyst/software/asset-jetconf/
##cp server_assetmgt.* /home/analyst/software/asset-jetconf/
##cp joerg@iosb.fraunhofer.de_curl.pem /home/analyst/software/asset-jetconf/tests-http/


######################################################
