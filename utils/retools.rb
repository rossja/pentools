module ReTools
# A set of methods useful when performing binary
# reverse engineering. Handy for malware analysis
# and pentesting.
# ---
# Author:: Jason Ross <algorythm@gmail.com>
# Copyright:: Copyright 2013 Jason Ross
# License:: Gnu Public License (GPL) version 3 or later 
# Version:: 0.1

require 'base64'

  # Convert hex to base64 encoded data.
  # Example usage: 
  #   mydata = HexTools.hex_to_b64(hexstring)
  def self.hex_to_b64(indata)
    hexstr = indata.scan(/../).map {|x| x.hex}.pack('c*')
    b64str = Base64.strict_encode64(hexstr)
    return b64str
  end

  # Convert base64 encoded data to hex
  # Example usage: 
  #   mydata = HexTools.b64_to_hex(b64data)
  def self.b64_to_hex(indata)
    b64str = Base64.strict_decode64(indata)
    hexstr = b64str.unpack('H*').first
    return hexstr
  end

  # Convert hex (eg. '414141') to ascii (eg. 'AAA').
  # This presumes that the hex data is only ascii...
  # Example usage: 
  #   mydata = HexTools.hex_to_ascii('414141')
  def self.hex_to_ascii(indata)
    ascstr = indata.scan(/../).map {|x| x.hex}.pack('c*')
    return ascstr
  end

  # Convert ascii (eg. 'AAA') to hex (eg. '414141').
  # Example usage: 
  #   mydata = HexTools.ascii_to_hex('AAA')
  def self.ascii_to_hex(indata)
    hexstr = indata.each_char.map {|x| x.unpack('H*')}.join
    return hexstr
  end

  # Perform a bitwise XOR on a string. The key has to be
  # the same length as the data (hence, fixed).
  # Example usage: 
  #   mydata = ReTools.fixed_xor(text, key)
  def self.fixed_xor(s1,s2)
    xored = (s1.to_i(16) ^ s2.to_i(16)).to_s(16)
    return xored
  end

  # Perform a bitwise XOR on a string. The key can be
  # a different length than the data (hence, looped).
  # Example usage: 
  #   mydata = ReTools.looped_xor(text, key)
  def self.looped_xor(s1,s2)
    xored = ""
    [s1.size,s2.size].max.times do |i|
      xored << ((s1[i] || 0).ord ^ (s2[i] || 0).ord)
    end
    return xored
  end

  # Returns an array of every ASCII character
  # Example usage:
  #   ascii_array = ReTools.ascii_strict
  #   ascii_array.each { |i| puts i }
  def self.ascii_strict
    ascii_array = ("\x00".."\x7f")
    return ascii_array
  end

  # Returns an array of every printable ASCII
  # character (including "Space")
  # Example usage:
  #   ascii_array = ReTools.ascii_printable
  #   ascii_array.each { |i| puts i }
  def self.ascii_printable
    ascii_array = ("\x20".."\x7e")
    return ascii_array
  end

end
