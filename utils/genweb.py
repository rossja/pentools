#!/usr/bin/env python3
import requests

# the following supresses warnings about invalid certs (handy for burp proxy)
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# comment out the proxy lines if you don't want to use one
proxies = {
    'http': 'http://127.0.0.1:8080',
    'https': 'http://127.0.0.1:8080'
}

requrl = "http://localhost/v1/hello"

# ---------------------
# Misc. variables
# ---------------------
referer = ""
origin = ""

# ---------------------
# Authentication Tokens
# ---------------------
apikey = "abcdef01323456789"
apisecret = "abcdef0123456789"
authtoken = "abcdef0123456789"
# ---------------------

# ---------------------
# Data to send on POST/PUT
# ---------------------
data = {
    "testdata": "test data is legit",
}
# ---------------------

# ---------------------
# User-Agent Strings
# ---------------------
# IE 11
ie11 = "Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko"
# Firefox
ffox = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1"
# Chrome
chrome = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
# ---------------------

# ---------------------
# Set which User-Agent to use
# ---------------------
ua = ie11

# ---------------------
# Main screen turn on
# ---------------------

# set headers with defined vars
headers = {
    "Cookie": '',
    "Referer": referer,
    "Authorization": "Bearer " + authtoken,
    "Origin": origin,
    "User-Agent": ua,
    "X-APIKEY": apikey
}


# GET
res = requests.get(requrl, headers = headers, proxies=proxies, verify=False)

# POST
#res = requests.post(requrl, headers = headers, proxies=proxies, verify=False, data=data)

# OPTIONS
#res = requests.options(requrl, headers = headers, proxies=proxies, verify=False)

# PUT
#res = requests.put(requrl, headers = headers, proxies=proxies, verify=False, data=data)

# DELETE
#res = requests.delete(requrl, headers = headers, proxies=proxies, verify=False)

# print out the response
print( "\nSTATUS: %s" % res.status_code )
#print( "\nresponse headers:\n%s\n" % str(res.headers) )
print( "\nHEADERS:")
for key in res.headers:
    print("%s: %s" % (key, res.headers[key]) )
print( "\nBODY:\n%s" % res.text )
print("\nNo more data in response.")
