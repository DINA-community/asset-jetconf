#!/usr/bin/python3
#
#####################################################
#
#  Projekt: BSI-507
#  Assetmanager Jetconf Backend
#  file: __init__.py
#
#####################################################
#
#  Joerg Kippe
#  Fraunhofer IOSB
#  Fraunhoferstr. 1
#  D-76131 Karlsruhe
#
####################################################

from jetconf import jetconf, config as jetconf_config
from jetconf.errors import JetconfInitError
from yangson.enumerations import ContentType, ValidationScope
from colorlog import info
import sys
import yaml
import os
import json
import os.path
sys.path.append(os.path.dirname(__file__) + '/../../asset-discovery/')
from datastore import L2Network, L3Network, Inventory, Device, L2Node, L3Node, NodeSupport, L3TerminationPoint, L2TerminationPoint, TPSupport, L2Link, L3Link, LinkSupport, User, ROOT_NETWORK, initialize_db, DATABASE
import broker
import threading
import time

conf = None
# expected at ${devicemanagement}/site/config.yaml
with open(os.path.dirname(__file__) + "/../../../site/config.yaml", "r") as stream:
    conf = yaml.safe_load(stream)
asset_manager = conf['asset-manager']
asset_discovery = asset_manager['asset-discovery']
publishing = asset_manager['general']['publishing']
topics = publishing['topics']
addresses = publishing['addresses']

mutex = threading.Lock()

initialize_db('RESTAPI')

jc_config = jetconf_config.JcConfig()
jc_config.load_file(os.path.dirname(__file__) + "/../topology-config.yaml")
JC = jetconf.Jetconf(jc_config)
ds_dump_filename = JC.config.glob["DATA_JSON_FILE"]


DATASTORE_TOPIC = topics['datastore_ready']
responder_ip = addresses['jetconf']['addr']
responder_port = addresses['jetconf']['port']

def response_listener(ep, topic):
    info ("response_listener started")
    sub = ep.make_subscriber(topic)
    while True:
        if sub.available():
            (t, d) = sub.get()
            x = threading.Thread(
                target=process_response, args=(
                    t, d), daemon=True)
            x.start()
        else:
            time.sleep(2)


responder_ep = broker.Endpoint()
responder_ep.listen(responder_ip, responder_port)
listener = threading.Thread(
    target=response_listener, args=(
        responder_ep, DATASTORE_TOPIC), daemon=True)
listener.start()

def process_response(t: str, d: str) -> None:
    """
    The procedure receives and processes the datastore ready message from asset discovery
    ns triggers the datastore rebuild.
    Args:
       t: the message topic
       d: dummy
    Result:
       None
    """
    if t == DATASTORE_TOPIC:
        info ("Message received, Rebuilding datastore")
        make_datastore(ds_dump_filename)
        try:
            JC.datastore.load()
        except (FileNotFoundError, YangsonException) as e:
            raise JetconfInitError(
                "Cannot load JSON data file \"{}\", reason: {}".format(
                    JC.config.glob["DATA_JSON_FILE"], ErrorHelpers.epretty(e)
                )
            )
        try:
            JC.datastore.get_data_root().validate(ValidationScope.all, ContentType.config)
            info ("Datastore rebuild")
        except (SchemaError, SemanticError) as e:
            raise JetconfInitError("Initial validation of datastore failed, reason: {}".format(ErrorHelpers.epretty(e)))


def make_datastore(ds_dump_filename: str) -> None:
    """
    This procedure rebuilds the JSON datastore used by the RESTCPNF API.
    Args:
       ds_dump_filename: the name of the datastore file
    Results:
       None
    """
    with open(ds_dump_filename, 'w') as ds_dump:
        mutex.acquire()
        DATABASE.connect(reuse_if_open=True)
        nets = []
        query3 = L3Network.select()
        for l3net in query3:
            nets = nets + [l3net]
        query2 = L2Network.select()
        for l2net in query2:
            nets = nets + [l2net]
        query1 = Inventory.select()
        for inv in query1:
            nets = nets + [inv]
        result = {"ietf-netconf-acm:nacm": {"enable-nacm":False}}
        networks = []
        for a_net in nets:
            networks = networks + a_net.make_yang_data()
        result['ietf-network:networks'] = {'network': networks}
        json.dump(obj=result, fp=ds_dump, indent=4)
        DATABASE.close()
        mutex.release()


if not os.path.exists(ds_dump_filename) or os.stat(ds_dump_filename).st_size == 0:
    print ("MAKING")
    make_datastore(ds_dump_filename)
    print ("DONE")

time.sleep(5)

info ("Backend __init__")
