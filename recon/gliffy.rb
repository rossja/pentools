#!/usr/bin/env ruby
# ----------------------------------------------------
# simple scraper of google dork for gliffy diagrams
# takes a query term as input, eg: "bank"
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

# search nodes by css selector
rslt.css('h3.r a').each do |lnk|
  puts "#{lnk.content}\n#{lnk['href']}\n\n"
end
