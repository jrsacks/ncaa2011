class Game
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
    begin
      doc = Hpricot(html)  
      doc.search("tr[@class=ysprow]").each {|p|
        idMatch = p.search('a').to_html.match(/[0-9]+/)
        line = p.inner_html.split("<\/td>")      
        pointMatch = line[-2].match(/[0-9]+/)
        unless pointMatch.nil? || idMatch.nil?
          score = Score.find_or_create_by_playerId_and_gameId(:playerId => idMatch[0], :gameId => gameId)
          score.points = pointMatch[0]
          score.save
          player = Player.where(:playerId => idMatch[0]).first
          teamScore[player.team] += pointMatch[0].to_i
        end
      }
      Rails.logger.info teamScore
      if final
        Player.where(:team => teamScore.index(teamScore.values.min)).each { |p|
          p.alive = false
          p.save
        }
      end
    rescue => e
      Rails.logger.error "Caught Error: #{e}"
    end
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
end
