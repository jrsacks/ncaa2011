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
    doc = Nokogiri::HTML(html)  
    doc.xpath('//tr[@class="ysprow"]').each {|p|
      idMatch = p.search('a').to_html.match(/[0-9]+/)
      line = p.inner_html.split("<\/td>")      
      pointMatch = line[-2].match(/[0-9]+/)
      unless pointMatch.nil? || idMatch.nil?
        score = Score.find_or_create_by_playerId_and_gameId(:playerId => idMatch[0], :gameId => gameId)
        score.points = pointMatch[0]
        score.save
        player = Player.where(:playerId => idMatch[0]).first
        player.current = true
        player.save
        teamScore[player.team] += pointMatch[0].to_i
      end
    }
    Rails.logger.info teamScore
    if final
      Player.where(:team => teamScore.index(teamScore.values.min)).each { |p|
        p.alive = false
        p.current = false
        p.save
      }
      Player.where(:team => teamScore.index(teamScore.values.max)).each { |p|
        p.current = false
        p.save
      }
    end
  end

  def findForDate(date)
    doc = Nokogiri::HTML(open("http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{date}"))
    doc.css('td a').each do |td|
      if td.text.include? 'Box Score'
        load td['href'].match(/[^0-9]*([0-9]*).*/)[1]
      end
    end
  end
end
