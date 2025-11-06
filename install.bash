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

echo "Installing jetconf starting..."

#checking for root rights
if [ $EUID != 0 ]; then
  echo -e '"Not enough minerals!" - Are you root? '
  exit 1
fi

apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get -y install libyang-tools git python3-pip python3-setuptools-scm


if python3 -c "import setuptools, sys; from packaging.version import parse; sys.exit(parse(setuptools.__version__) < parse('68.0.0'))"; then
    echo "setuptools >= 68.0.0"
else
    echo "setuptools too old, upgrading..."
    python3 -m pip install --upgrade "setuptools==68.*"
fi

python3 -m pip install --upgrade pip

# legacy for pip < v23.0+
if python3 -m pip install -h 2>&1 | grep -q -- '--break-system-packages'; then
  python3 -m pip install --break-system-packages -r requirements.txt
  python3 -m pip install --break-system-packages -e .
else
  python3 -m pip install -r requirements.txt
  python3 -m pip install -e .
fi

echo "Start credentials..."

pushd utils/cert_gen
#Generate ca.pem and ca.key if not present in folder. READ HOWTO_SERVER.txt
echo "PWD=$(pwd)"
ls -l ca.pem ca.key || (openssl genrsa -out ca.key 4096; \
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.pem -subj "/CN=Test CA")
./gen_server_cert.sh assetmgt bsi.corp
./gen_client_cert.sh analyst@bsi.corp
popd

######################################################