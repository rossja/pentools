#!/usr/bin/env python
# ----------------------------------------------------
# a simple firewalker, using scapy
# ----------------------------------------------------
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ----------------------------------------------------
# Copyright 2010 Jason Ross <algorythm /at/ gmail /dot/ com>
# ----------------------------------------------------
# version: 0.3
# ----------------------------------------------------

import sys
from optparse import OptionParser
from scapy.all import sr,IP,TCP,UDP,ICMP,conf    # sr,IP,TCP,UDP,ICMP,conf

version="fakir: a firewalker script using scapy\nversion: 0.2\nauthor: jason ross <algorythm@gmail.com>"
usage="usage: %prog DSTNET TTL"
parser = OptionParser(usage=usage, version=version)

# set up command line arguments
parser.set_defaults(verbose="false")

parser.add_option("-v", "--verbose", dest="verbose",
                  action="store_true", help="turn on/off scapy verbosity")
parser.add_option("-d", "--dst-net", dest="dstnet",
                  action="store", help="set the destination network (CIDR notation only)")
parser.add_option("-t", "--ttl", dest="dstttl",
                  action="store", help="set the TTL to the destination gateway")
                  
parser.add_option("-p", "--dport", dest="tports",
                  action="store", help="set the destination ports")

# process command line arguments
(options, args) = parser.parse_args()

# exit if we're missing options
if (not options.verbose or not options.dstnet or not options.dstttl):
   print "\n"+sys.argv[0]+": missing parameter(s)\n"
   parser.print_help()
   print "\n"
   sys.exit(1)

tports = []
# set default ports if none were specified
if (not options.tports):
   # set destination ports
   # (mostly stolen from the nmap 'top 10' lists
   # list. thanks for nmapping 0.0.0.0 fyodor! =)
   tports = [21,22,23,25,80,135,139,443,445,3389,5060,5061]
else:
   # loop through specified ports if specified
   for tport in options.tports.split(','):
      if '-' in tport:
         portition = tport.partition('-')
         frist=int(portition[0])
         lsat=int(portition[2])
         for prange in range(frist,lsat+1):
            tports.append(int(prange))
      else:
         tports.append(int(tport))

# TODO: set up UDP ports as well
uports = [53,67,123,135,137,138,139,161,445,1434,5060]
   

# set the scapy verbosity config var
conf.verb = options.verbose



def main():
   print "\nBeginning firewalk of %s\n" % (options.dstnet)
   print "Using the following ports:\n %s\n\n" % (tports)

   # TODO: automate traceroute var discovery
   # traceroute(options.dstnet)
    
   res_c,unans = sr(IP(dst=options.dstnet, ttl=int(options.dstttl))/TCP(dport=tports,flags="S",options=[('Timestamp',(0,0))]), timeout=2, retry=-2)
   res_c.make_lined_table(lambda (s,r):(s.dport, s.dst, r.sprintf("{TCP:%TCP.flags%}{ICMP:%IP.src%#%r,ICMP.type%}")))


if __name__ == "__main__":
   main()
