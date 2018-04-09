#!/usr/bin/env python3
import requests

# the following supresses warnings about invalid certs (handy for burp proxy)
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

proxies = {
    'http': 'http://127.0.0.1:8080',
    'https': 'http://127.0.0.1:8080'
}

requrl = "http://api.test/v0/hello"

token = "NOTOKEN"

headers = {
    "Cookie": '',
    "Referer": "",
    "Authorization": "Bearer " + token,
}

data = {
    "testdata": "testing, testing, 1..2..3"
}

# with proxy
# GET
res = requests.get(requrl, headers = headers, proxies=proxies, verify=False)
# POST
#res = requests.post(requrl, headers = headers, proxies=proxies, verify=False, data=data)
# OPTIONS
#res = requests.options(requrl, headers = headers, proxies=proxies, verify=False)

# without proxy
# GET
#res = requests.get(requrl, headers = headers, proxies=proxies, verify=False)
# POST
#res = requests.post(requrl, headers = headers, proxies=proxies, verify=False, data=data)
# OPTIONS
#res = requests.options(requrl, headers = headers, proxies=proxies, verify=False)

# print out the response
print( "\nSTATUS: %s" % res.status_code )
#print( "\nresponse headers:\n%s\n" % str(res.headers) )
print( "\nHEADERS:")
for key in res.headers:
    print("%s: %s" % (key, res.headers[key]) )
print( "\nBODY:\n%s" % res.text )
print("\nNo more data in response.")
