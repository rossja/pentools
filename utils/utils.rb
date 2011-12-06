#!/usr/bin/env ruby
# ----------------------------------------------------
# misc. utilities for ruby
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
# version: 0.5
# ----------------------------------------------------

def a2h(txt)
# ascii to hex conversion
# example usage:
#   a2h('AAA').each { |char| puts "0x" + char }
  hex = Array.new
  txt.each_char { |byte|
    hex << byte.unpack('H*')[0]
  }
  return hex
end

def h2a(hex)
# hex to ascii conversion
# example usage: 
#   h2a('41 41 41').each { |char| puts char }
  ascii = Array.new
  hex.split(' ').each { |val|
    ascii << val.hex.chr
  }
  return ascii
end
