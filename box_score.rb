require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'hpricot'

def load(gameId)
  stringIo = open("http://rivals.yahoo.com/ncaa/basketball/boxscore?gid=#{gameId}")
  final = false
  html = stringIo.read

  teamScore = Hash.new(0)
  doc = Nokogiri::HTML(html)
  doc.css('#ysp-reg-box-line_score .final').each{ |p|
    final = true
  }

  doc.css('#ysp-reg-box-game_details-game_stats .bd tbody tr').each{ |p|
    idMatch = p.search('a').to_html.match(/[0-9]+/)
    points = p.search('td').last.text
    unless points.nil? || idMatch.nil?
      puts "#{idMatch[0]} #{points}"
    end
  }

  puts final
end


load '201103100459'
