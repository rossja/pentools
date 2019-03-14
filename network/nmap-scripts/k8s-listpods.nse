local nmap = require "nmap"
local shortport = require "shortport"
local http = require "http"
local stdnse = require "stdnse"
local string = require "string"

description = [[
Attempts to obtain Kubernetes pod information from the read-only
(kubelet API service - port 10255), which must be open on the target system.

If successful, the JSON data returned by the API is returned.
]]

---
-- Queries Kubernetes for pod information using the read-only kubelet API service
--
-- @usage nmap -p 10255 --script k8s-listpods <target>
-- @output
-- | Pods: {json-data-blob}

author = "Jason Ross <algorythm@gmail.com>"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = {"default", "safe"}

portrule = shortport.portnumber(10255, "tcp", "open")

action = function(host, port)
  -- Perform a GET request for /pods
	local path = "/pods"
	stdnse.debug(1 "attempting HTTP GET to %s", path)
  local response = http.get(host,port,path)
  local result = {}

  -- Fail if there is no data in the response, the response body or if the HTTP status code is not successful
  if not response or not response.status or response.status ~= 200 or not response.body then
    stdnse.debug(1, "Failed to retrieve: %s", path)
    return
  end

  -- Fail if this doesn't appear to be Kubernetes PodList
  if not string.match(response.body, "\"kind\":\"PodList\"") then
    stdnse.debug(1, "%s does not appear to be a Kubernetes PodList", path)
    return
	end
	
	result = stdnse.output_table()
	result["Pods"] = response.body
	return result
end
