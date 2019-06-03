#!/bin/bash
# ----------------------------------------------------
# Simple script to automate trying various SNMP strings
# against hosts. The community strings to try are taken
# from the NMAP snmp_brute script. This goes one better
# than that in that it walks the whole tree and dumps
# the data to files.
#
# snmp.hosts can be generated from a .gnmap file eg.:
# awk '/161\/open\/udp/ {print $2}' *UDP*.gnmap|ipsort > snmp.hosts
# supports v1 or v2c scan - defaults to v1
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
# Copyright 2015 Jason Ross <algorythm /at/ gmail /dot/ com>
# ----------------------------------------------------


TIMEOUT=3 # sets the snmpwalk host timeout (in seconds)

for HOST in `cat snmp.hosts`
do
   echo ---------------------------------------------
   echo ${HOST}
   for USER in public private admin cisco snmpd mngt
   do
      case $1 in
         1)
            snmpwalk -v 1 -t ${TIMEOUT} -c ${USER} ${HOST} > ${HOST}_${USER}.txt
         ;;

         2c)
            snmpwalk -v 2c -t ${TIMEOUT} -c ${USER} ${HOST} > ${HOST}_${USER}.txt
         ;;

         *)
            snmpwalk -v 1 -t ${TIMEOUT} -c ${USER} ${HOST} > ${HOST}_${USER}.txt
         ;;
      esac
   done
done
