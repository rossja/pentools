#!/usr/bin/env ruby
# -------------------------------------------------
# misc. utilities
# author: rossja <algorythm /at/ gmail /dot/ com
# version: 0.5
# -------------------------------------------------

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
