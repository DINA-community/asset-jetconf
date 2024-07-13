from colorlog import info
from typing import List, Dict, Union, Any

from yangson.instance import InstanceRoute, MemberName
from jetconf.data import BaseDatastore, DataChange
from jetconf.helpers import ErrorHelpers, LogHelpers
from jetconf.handler_base import ConfDataListHandler
from jetconf.handler_base import ConfDataObjectHandler
from jetconf.helpers import DataHelpers
from jetconf.jetconf import JC
from jetconf.errors import HandlerError

from datastore import Device, DATASTORE

import re

JsonNodeT = Union[Dict[str, Any], List]
epretty = ErrorHelpers.epretty
debug_confh = LogHelpers.create_module_dbg_logger(__name__)

# ---------- User-defined handlers follow ----------


node_pat = re.compile("node\[node-id=\"([0-9]+)\"\]")

network_pat = re.compile("network\[network-id=\"(L3[0-9]+)\"\]")

class AssetMgtConfListHandler(ConfDataListHandler):
    
    def create_item(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " replace triggered")
        info("Creating list '/ietf-network:networks' in app configuration")

    def replace_item(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " replace triggered")
        info("Replacing list '/ietf-network:networks' in app configuration")

    def delete_item(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " delete triggered")
        info("Deleting list '/ietf-network:networks' from app configuration")

class AssetMgtConfCatchAll(ConfDataObjectHandler):

    def create_item(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " replace triggered")
        info("Creating object '/ietf-network:networks' in app configuration")
    
    def replace(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " replace triggered")
        info("Replacing object '/ietf-network:networks' Catch all")
        raise HandlerError("error")
        

    def delete_item(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " delete triggered")
        info("Deleting object '/ietf-network:networks' in app configuration")

class AssetMgtConfObjectHandler(ConfDataObjectHandler):

    def create_item(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " replace triggered")
        info("Creating object '/ietf-network:networks' in app configuration")
    
    def replace(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " replace triggered")
        str_lst = str(ii).split("/")
        network_id = False
        node_id = False
        for x in str_lst:
            net_match = network_pat.match(x)
            node_match = node_pat.match(x)
            if net_match:
                network_id = net_match.group(1)
            if node_match:
                node_id = node_match.group(1)
        print (ch.__dict__['input_data'])
        DATABASE.connect(reuse_if_open=True)
        if 'asset-inventory-model:vendor' in ch.__dict__['input_data']:
            Device.get(Device.id == node_id).set_vendor(ch.__dict__['input_data']['asset-inventory-model:vendor'])
            info("Replacing object '/ietf-network:networks/network/node/asset-inventory-model:device-attributes/vendor' in app configuration")
            
        elif 'asset-inventory-model:deviceType' in ch.__dict__['input_data']:
            Device.get(Device.id == node_id).set_deviceType(ch.__dict__['input_data']['asset-inventory-model:deviceType'])
            info("Replacing object '/ietf-network:networks/network/node/asset-inventory-model:device-attributes/deviceType' in app configuration")
            
        elif 'asset-inventory-model:product' in ch.__dict__['input_data']:
            Device.get(Device.id == node_id).set_product(ch.__dict__['input_data']['asset-inventory-model:product'])
            info("Replacing object '/ietf-network:networks/network/node/asset-inventory-model:device-attributes/product' in app configuration")
        DATABASE.close()

    def delete_item(self, ii: InstanceRoute, ch: "DataChange"):
        debug_confh(self.__class__.__name__ + " delete triggered")
        info("Deleting object '/ietf-network:networks' in app configuration")
        
def register_conf_handlers(ds: BaseDatastore):
    ds.handlers.conf.register(AssetMgtConfObjectHandler(ds, "/ietf-network:networks/network/node/asset-inventory-model:device-attributes/vendor"))
    ds.handlers.conf.register(AssetMgtConfObjectHandler(ds, "/ietf-network:networks/network/node/asset-inventory-model:device-attributes/deviceType"))
    ds.handlers.conf.register(AssetMgtConfObjectHandler(ds, "/ietf-network:networks/network/node/asset-inventory-model:device-attributes/product"))
    
    ds.handlers.conf.register(AssetMgtConfCatchAll(ds, "/ietf-network:networks"))



