require 'nokogiri'
require 'open-uri'
# for debugging
# require 'pry'
require 'json'

class Scraper
  quest_hash = {}

  document = Nokogiri::HTML.parse(URI.open('https://ddowiki.com/page/Quests_by_level_and_XP'))

  # headers same for both tables
  headers = document.css('table')[0].css('tr')[0].css('th').map{|a| a.text.chomp}

  # scrape heroic quest info
  quest_hash[:heroic] = document.css('table')[0].css('tr').map{|tr|
    tr.css('td').each_with_index.map{|a, index| [headers[index], a.text.chomp]}.to_h
  }
  # scrape epic quest info
  quest_hash[:epic] = document.css('table')[1].css('tr').map{|tr|
    tr.css('td').each_with_index.map{|a, index| [headers[index], a.text.chomp]}.to_h
  }

  # write to a file
  File.open('./data/quest_list.json', 'w') { |file| file.write(JSON.generate(quest_hash)) }

  # for debugging
  # binding.pry
end