class Game
  def load(gameId)
    stringIo = open("http://rivals.yahoo.com/ncaa/basketball/boxscore?gid=#{gameId}")
    html = stringIo.read
    (1..2).each { |i| html.gsub!("ysprow#{i}","ysprow") }  

    doc = Hpricot(html)  
    doc.search("tr[@class=ysprow]").each {|p|
      idMatch = p.search('a').to_html.match(/[0-9]+/)
      line = p.inner_html.split("<\/td>")      
      pointMatch = line[-2].match(/[0-9]+/)
      unless pointMatch.nil? || idMatch.nil?
        score = Score.find_or_create_by_playerId_and_gameId(:playerId => idMatch[0], :gameId => gameId)
        score.points = pointMatch[0]
        score.save
      end
    }
  end

end
