require 'open-uri'
require 'nokogiri'
require 'json'

def openUrl(url)
	html = open(url)
	doc = Nokogiri::HTML(html)
	return doc
end

page = openUrl('https://uk.wikipedia.org/wiki/%D0%9C%D1%96%D1%81%D1%82%D0%B0-%D0%BC%D1%96%D0%BB%D1%8C%D0%B9%D0%BE%D0%BD%D0%BD%D0%B8%D0%BA%D0%B8_%D1%81%D0%B2%D1%96%D1%82%D1%83')
table = page.css('tbody tr td:first-child').text
a = table.split('\n')
l = []
a.each do |city|

	l.append(city)
end
l.each do |one|
	l.append(one + ' 1')
end
puts l.first