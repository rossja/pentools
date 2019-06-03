local nmap = require "nmap"
local http = require "http"
local stdnse = require "stdnse"
local string = require "string"
local table = require "table"

description = [[
Generic check of a remote port
]]

---
-- Generic check of a remote port
--
-- @usage nmap -p 80 --script port-check <target>
-- @usage nmap -sV --script port-check <target>
-- @output
-- Data:
-- | 	data

author = "Jason Ross <algorythm@gmail.com>"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = {"default", "safe"}

portrule = function(host, port)
	local dst_port = { number=10255, protocol="tcp" }
	local svc_check = nmap.get_port_state(host, dst_port)

	return svc_check ~= nil
		and svc_check.state == "open"
		and port.protocol == "tcp"
		and port.state == "open"
end