require 'open-uri'
require 'nokogiri'
require 'json'

class WebScrapper
	def openUrl(url)
		html = open(url)
		doc = Nokogiri::HTML(html)
		return doc
	end

	def getAllResumes
		doc = openUrl('https://eurabota.com/job/seeking/')
		links = []
		doc.css('.tt').each do |block|
			if /^\/v\//.match(block['href'])
				links.append(block['href'])
			end
		end
		return links
	end

	def findPhones(text)
		return text.match(/\d[0-9]{9-12}/) #+380993633780
	end

	def getDitailsFromAllResumes
		resumes = []
		links = getAllResumes
		links.each do |link|
			doc = openUrl('https://eurabota.com' + link)
			discription = doc.css('#job-description').text.gsub(/\t/, '')
			digits = findPhones(discription)
			authorName = doc.css('.authorName').text
			resumes.push(
				author: authorName,
				description: discription,
				phones: digits,
				link: link
			)
		end
		return resumes
	end
end