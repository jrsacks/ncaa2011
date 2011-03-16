require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Game
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
        score = Score.find(:first, :conditions => {:playerId => idMatch[0], :gameId => gameId.to_i - 201100000000})
        if score.nil?
          score = Score.new
          score.playerId = idMatch[0]
          score.gameId = gameId.to_i - 201100000000
        end
        score.points = points
        score.save
        player = Player.find(:first, :conditions => {:playerId => idMatch[0]})
        player.current = true
        player.save
        teamScore[player.team] += points.to_i
      end
    }

    if final
      Player.find(:all, :conditions => {:team => teamScore.index(teamScore.values.min)}).each { |p|
        p.alive = false
        p.current = false
        p.save
      }
      Player.find(:all, :conditions => {:team => teamScore.index(teamScore.values.max)}).each { |p|
        p.current = false
        p.save
      }
    end
  end

  def findForDate(date)
    stringIo = open("http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{date}")
    doc = Nokogiri::HTML(stringIo.read)
    doc.css('td a').each do |td|
      if td.text.include? 'Box Score'
        load td['href'].match(/[^0-9]*([0-9]*).*/)[1]
      end
    end
  end
end
