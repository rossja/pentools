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
require 'uri'
require 'htmlentities'

# ----------------------------------------------------
# This next bit is designed to handle the args.
# Maltego throws everything to the script in a weird
# way. For example, a query of "bank account" in 
# maltego would call this script like so:
#   maltego_gliffy.rb bank account text=bank account
# Accordingly, we need to split the args, and then
# URL encode the actual search phrase.
# ----------------------------------------------------
args = ARGV.join(" ")
junk,mterm = args.split('=')
qterm = URI.escape(mterm)

# ----------------------------------------------------
# start building the body of the maltego XML output
# ----------------------------------------------------
head = <<-"HEAD"
  <MaltegoMessage>
    <MaltegoTransformResponseMessage>
      <Entities>
HEAD
puts "#{head}"

# ----------------------------------------------------
# open the google results page and scrape it
# ----------------------------------------------------
rslt = Nokogiri::HTML(open("http://www.google.com/search?q=inurl%3Apublish+site%3Agliffy.com+#{qterm}"))

# ----------------------------------------------------
# search results page for hits (using css selector)
# and wrap the Maltego Entity XML around the results
# We need to encode XML entities (like '&'), to keep
# maltego happy, so we use htmlentities for that.
# ----------------------------------------------------
rslt.css('h3.r a').each do |lnk|
  coder = HTMLEntities.new
  data = <<-"DATA"
        <Entity Type="URL">
          <Value>#{coder.encode(lnk.content)}</Value>
          <Weight>100</Weight>
          <AdditionalFields>
            <Field Name="theurl">#{coder.encode(lnk['href'])}</Field>
            <Field Name="fulltitle">#{coder.encode(lnk.content)}</Field>
          </AdditionalFields>
        </Entity>
  DATA
  puts "#{data}"
end

# ----------------------------------------------------
# finish building the body of the maltego XML output
# ----------------------------------------------------
foot = <<-"FOOT"
      </Entities>
    </MaltegoTransformResponseMessage>
  </MaltegoMessage>
FOOT
puts "#{foot}"
