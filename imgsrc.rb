#!/usr/local/bin/ruby

require 'net/http'
require 'pp'

if ARGV.size < 1 or ARGV.size > 2
        puts ""
	puts "Copyright (c) 2008 Gabriel Medina/Rha7.Com."
	puts "Released under the LGPL license."
	puts ""
        puts ""
        puts "USAGE:"
        puts ""
        puts "     imgsrc <filename.ext|url> [--bare]"
        puts ""
        puts "     filename.ext is the HTML source to explore."
        puts "     --bare indicates that imgsrc shouldnt wait for a key nor output any extra text (used for scripting)"
        puts ""
        exit 1
end

filename = ARGV[0]
bare = false

if ARGV.size >= 2
	if ARGV[1] == '--bare'
		bare = true
	end
end

content = String.new
ishttp = false
if filename.strip[0..3].downcase == 'http'
	content = Net::HTTP.get(URI.parse(filename.strip))
	ishttp = true
elsif File.exists?(filename)
	content = IO.read(filename)
else
	puts ""
	puts "File does not exist."
	puts ""
	exit 1
end

puts "Copyright (c) 2008 Gabriel Medina/Rha7.Com." unless bare
puts "" unless bare



tclean=content.gsub("\n", '').gsub(/ +/, ' ').gsub("\t", ' ').gsub(/< *?img/i, "\n<img").gsub(/>/, ">\n")
re = /<img.*?>/im
matches = tclean.grep(re)

results = Array.new
re = /src *= *['"](.*?)["']/i
matches.to_a.each do |match|
        str=re.match(match)
        results << str[1].gsub(/.*:\/\//,'').gsub(/\/.*/, '')
end


results = results.map{|i| i.strip.length > 0 ? i : nil }.compact.sort.uniq

puts "Image Sources" unless bare
puts "=============" unless bare
results.each { |res| puts res }
puts "=============" unless bare
puts "" unless bare
puts "Press [ENTER] key to leave." unless bare
STDIN.gets.chomp unless bare




