#!/usr/bin/env ruby
# ----------------------------------------------------
# what may be the most brain dead fuzzer ever written.
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
# version: 0.1
# ----------------------------------------------------
require 'socket'

@host = '127.0.0.1'
@port = 22

# interactive socket picker
print "[U]DP, or [T]CP? "
@ctyp = gets.chomp.downcase

# interactive overflow  builder
#print "number of A? "
#@numa = gets.chomp.to_i
@numa = 10

def con(numa)
  # build the overflow string
  bof = ""
  numa.times do bof << 'A' end

  # stupid ruby socket and its lack of
  # consistency between UDP and TCP...
  case @ctyp
    when "tcp","t"
      sock = TCPSocket.new(@host, @port)
    when "udp","u"
      sock = UDPSocket.new()
      sock.connect(@host, @port)
    else
      print "unknown connection type. defaulting to TCP"
      sock = TCPSocket.new(@host, @port)
  end

  # print the overflow string to the socket
  #sock.print "#{bof}\n"
  sock.send "#{bof}\n", 0
  resp = sock.gets(nil)
  #p u1.recvfrom(10) #=> ["uuuu", ["AF_INET", 33230, "localhost", "127.0.0.1"]]
  sock.close

  # report on wtf we did
  print "Sent #{numa} 'A' chars\n"
  print "\nData returned:\n#{resp}\n"
end

# just doit!
for numa in 1..@numa
  con(numa)
end
