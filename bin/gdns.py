#! /usr/bin/env python3

import json, requests 

url = "https://dns.google.com/resolve" 
params = dict( 
    name='www.potaroo.net', 
    type='A', 
    dnssec='true' 
) 

resp = requests.get(url=url, params=params) 
data = json.loads(resp.text) 

print (data[u'Answer'][0][u'data'])
