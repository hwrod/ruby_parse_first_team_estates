#!/usr/bin/env ruby

require 'cgi'
cgi = CGI.new
str = cgi.params['str'][0].gsub("\r",'') if cgi.params['str'][0]


puts "Content-type: text/html", ""
puts "<html><body>"
puts "<center style='font-family:Arial'><pre><form method='post' name='form'>First Team Estates Text: <textarea id='str' name='str' style='width:50%;height:150px;cursor:pointer;font-weight:bold;color:red' onclick='this.select()'>",str,"</textarea>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\n\n<input type='button' style='width: 300px; height: 50px' onclick='document.getElementById(\"str\").value = document.getElementById(\"str\").value.replace(/&trade;|&copy;/g,\"\");document.forms[0].submit()' value='Parse &gt;&gt;'>\n\n"


if !str.empty? then
	str += 'ENDOFDOCUMENT'
	puts "Parsed: <textarea id='str' name='str' style='width:50%;height:300px;cursor:pointer;font-weight:bold;color:green' onclick='this.select()'>"
	names = str.scan(/(.*?)\nLicense #/)
	i = 0
	for name in names
		name = "#{name}".gsub(/\[|\]|"/, '')
		name2 = "#{names[i+1]}".gsub(/\[|\]|"/, '')
		if name2.empty? then
			name2 = "ENDOFDOCUMENT"
		end
		str.scan(/(#{name}.*?)#{name2}/ism) {
			|entry|
			entry = "#{entry}".gsub(/\\t/, '').gsub(/\\n/, "\n")
			puts 'Name: '+name
			licemail = entry.scan(/License # (.*?)\n.*?(.*?@.*?)\n/) 
			print "License #: "
			for licem in licemail
				print licem[0]
			end
			puts
			print "Email: "
			for licem in licemail
				print licem[1]
			end	
			puts
			phones = entry.scan(/(\(...\) ...-....)/)
			phones = "#{phones}".gsub(/\[|\]|"/, '')
			puts 'Phones: '+phones
			puts "\n"
		}
		i = i + 1
	end
	puts "</textarea>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
end

puts "</pre></center></body></html>"
