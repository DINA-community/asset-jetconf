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

echo "Installing starting..."

git config user.email "root@assetmanager.bsi.corp"

HOME=`pwd`

python3 -m pip install jetconf

pip install pyang

apt-get -y install yang-tools

cd /home/asset-manager/software/asset-jetconf
python3 setup.py install
cp /home/asset-manager/software/asset-jetconf/journal.py /usr/local/lib/python3.10/dist-packages/jetconf/

cd /home/asset-manager/software/asset-jetconf/utils/cert_gen
#./gen_server_cert.sh assetmgt 172.16.15.1.82
#./gen_client_cert.sh joerg@iosb.fraunhofer.de
./gen_server_cert.sh assetmgt bsi.corp
./gen_client_cert.sh analyst@bsi.corp

##cp ca.pem /home/asset-manager/software/asset-jetconf/
##cp server_assetmgt.* /home/asset-manager/software/asset-jetconf/
##cp joerg@iosb.fraunhofer.de_curl.pem /home/asset-manager/software/asset-jetconf/tests-http/


######################################################
