require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'hpricot'

def load(gameId)
  stringIo = open("http://rivals.yahoo.com/ncaa/basketball/boxscore?gid=#{gameId}")
  final = false
  html = stringIo.read
  (1..2).each { |i| 
    html.gsub!("ysprow#{i}","ysprow") 
  }  

  html.each { |line|
    final = true if line.include? "Final</span>&nbsp;"
  }

  teamScore = Hash.new(0)
  doc = Nokogiri::HTML(html)
  doc.xpath('//tr[@class="ysprow"]').each {|p|
    idMatch = p.search('a').to_html.match(/[0-9]+/)
    line = p.inner_html.split("<\/td>")      
    pointMatch = line[-2].match(/[0-9]+/)
    unless pointMatch.nil? || idMatch.nil?
      puts "#{idMatch[0]} #{pointMatch[0]}"
    end
  }
end

def findForDate(date)
  page = "http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{date}"
  open(page) { |f| 
    f.each_line { |line|
      if line.include? "\/ncaab\/boxscore?gid="                 
        #if not final already
        load line.match(/[^0-9]*([0-9]*).*/)[1]
      end
    }
  }
end


def loadTeam(teamAbbrev)
  stringIo = open("http://rivals.yahoo.com/ncaa/basketball/teams/#{teamAbbrev}/roster")
  html = stringIo.read

  teamname = ''
  players = []
  html.each do |line|
    if line.match(/<title>/)
      teamname =  (Nokogiri::HTML(line)/"title").inner_html.split(' -')[0]
    end
    if line.match(/\/ncaab\/players\/[0-9]+/) 
      idMatch = line.match(/[0-9]+/)
      fullname = (Nokogiri::HTML(line)/"a").inner_html.split(', ').reverse.join(' ')

      players << {:fullname => fullname, :team => teamname, :id => idMatch[0]}

      #unless idMatch.nil?
      #  player = Player.find_or_create_by_playerId(:playerId => idMatch[0])
      #  player.name = fullname
      #  player.team = teamname
      #  player.alive = true
      #  player.save
      #end
    end
  end
  puts players
end

def all()
  doc = Nokogiri::HTML(open("http://rivals.yahoo.com/ncaa/basketball/teams"))
  teams = []
  doc.search("a").each do |line|
    if line.to_html.match(/ncaab\/teams\//)
      abbrev = line.to_html.match(/ncaab\/teams\/(.*)\"/)[1]
      teams << abbrev
    end
  end

  puts teams.length
end

load '201102260363'
