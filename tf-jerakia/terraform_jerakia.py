"""
Provides the functionality to feed TF templates with Jerakia lookups
"""

import sys
import os
from jerakia import Jerakia
from terraform_external_data import terraform_external_data

def retrieveLookupInfo(query,item):
    lookitem = query[item]
    lookuppath =lookitem.split('/')
    key = lookuppath.pop()
    namespace = lookuppath

    if not namespace:
        raise Exception("No namespace given %s" % item )

    return namespace,key

@terraform_external_data
def lookupJerakia(query,variables=None):
    jerakia = Jerakia(configfile=os.path.abspath('utils/jerakia.yaml'))
    resdict = {}
    for item in query:
        namespace,key = retrieveLookupInfo(query,item)
        ret = []
        response = jerakia.lookup(key=key, namespace=namespace, variables=variables)
        ret.append(response['payload'])
        resdict.update({item: str(ret)})
    return resdict

if __name__ == '__main__':
    lookupJerakia()