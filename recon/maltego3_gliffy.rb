#!/usr/bin/env ruby
#!/usr/bin/env ruby
# ----------------------------------------------------
# takes a maltego Phrase entity as input: "bank"
# runs a google dork for gliffy diagrams matching
# the phrase. returns maltego URL entities 
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
# Copyright 2012 Jason Ross <algorythm /at/ gmail /dot/ com>
# ----------------------------------------------------
# version: 0.1
# ----------------------------------------------------

require 'nokogiri'
require 'open-uri'
qterm = ARGV[0]
rslt = Nokogiri::HTML(open("http://www.google.com/search?q=inurl%3Agliffy.com%2Fpublish+#{qterm}"))

head = <<-"HEAD"
  <MaltegoMessage>
    <MaltegoTransformResponseMessage>
      <Entities>
HEAD
puts "#{head}"

# search nodes by css selector
rslt.css('h3.r a').each do |lnk|
  data = <<-"DATA"
        <Entity Type="URL">
          <Value>#{lnk.content}</Value>
          <Weight>100</Weight>
          <AdditionalFields>
            <Field Name="theurl">#{lnk['href']}</Field>
            <Field Name="fulltitle">#{lnk.content}</Field>
          </AdditionalFields>
        </Entity>
  DATA
  puts "#{data}"
end

foot = <<-"FOOT"
      </Entities>
    </MaltegoTransformResponseMessage>
  </MaltegoMessage>
FOOT
puts "#{foot}"
