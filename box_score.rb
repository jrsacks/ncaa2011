require 'rubygems'
require 'open-uri'
require 'hpricot'

#tested by running through real data from yahoo before tourney

class Score
  def initialize(playerId, gameId, points)
    @playerId = playerId
    @gameId = gameId
    @points = points
  end
end

def get_players_from_game(gameId)
  stringIo = open("http://rivals.yahoo.com/ncaa/basketball/boxscore?gid=#{gameId}")
  html = stringIo.read
  (1..2).each { |i| html.gsub!("ysprow#{i}","ysprow") }  

  doc = Hpricot(html)  
  scores = []
  doc.search("tr[@class=ysprow]").each {|p|
    id = p.search('a').to_html.match(/[0-9]+/)
    id = id[0] unless id.nil?
    line = p.inner_html.split("<\/td>")      
    points = line[-2].match(/[0-9]+/)
    points = points[0] unless points.nil?
    scores << Score.new(id, gameId, points)
  }
  scores.each { |score| puts score.inspect }
  scores
end

class Player
  def initialize(id, name, team)
    @id = id
    @name = name
    @team = team
  end

  def to_s
    "#{@id}: #{@name} (#{@team})"
  end
end

def get_players_for_team(team)
  stringIo = open("http://rivals.yahoo.com/ncaa/basketball/teams/#{team}/roster")
  html = stringIo.read

  players = []
  teamname = ''
  html.each do |line|
    if line.match(/<title>/)
      teamname =  (Hpricot(line)/"title").inner_html.split(' -')[0]
    end
    if line.match(/\/ncaab\/players\/[0-9]+/) 
      id = line.match(/[0-9]+/)
      fullname = (Hpricot(line)/"a").inner_html.split(', ').reverse.join(' ')
      players.push Player.new(id, fullname, teamname)
    end
  end

  players.each { |player| puts player.to_s}
end

class Team
  attr_accessor :name, :abbrev
  def initialize(name, abbrev)
    @name = name
    @abbrev = abbrev
  end

  def to_s
    "#{@name} (#{@abbrev})"
  end
end

def get_all_teams()
  stringIo = open("http://rivals.yahoo.com/ncaa/basketball/teams")
  html = stringIo.read

  teams = []
  doc = Hpricot(html)
  doc.search("a").each do |line|
    if line.to_html.match(/ncaab\/teams\//)
      abbrev = line.to_html.match(/ncaab\/teams\/(.*)\"/)[1]
      name = line.inner_html.gsub('&nbsp;',' ')
      teams.push Team.new(name, abbrev)
    end
  end

  teams
end

def all_players()
  teams = get_all_teams()
  players = []
  start = false
  teams.each do |team|
    start = true if team.abbrev == 'aan'
    if(start)
      puts "Finding players for #{team}"
      get_players_for_team(team.abbrev, team.name).each do |player|
        players.push player
      end
    end
  end

  puts players.length
end

#get_players_from_game('201102010657')
get_players_for_team("kaa")#, "Kansas Jayhawks")
#get_all_teams()
#all_players()
