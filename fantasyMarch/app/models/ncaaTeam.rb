class Ncaateam
  def load(teamAbbrev)
    stringIo = open("http://rivals.yahoo.com/ncaa/basketball/teams/#{teamAbbrev}/roster")
    html = stringIo.read

    teamname = ''
    html.each do |line|
      if line.match(/<title>/)
        teamname =  (Hpricot(line)/"title").inner_html.split(' -')[0]
      end
      if line.match(/\/ncaab\/players\/[0-9]+/) 
        idMatch = line.match(/[0-9]+/)
        fullname = (Hpricot(line)/"a").inner_html.split(', ').reverse.join(' ')

        unless id.nil?
          player = Player.find_or_create_by_playerId(:playerId => idMatch[0])
          player.name = fullname
          player.team = teamname
          player.alive = true
          player.save
        end
      end
    end
  end

  def all
    stringIo = open("http://rivals.yahoo.com/ncaa/basketball/teams")
    html = stringIo.read

    doc = Hpricot(html)
    doc.search("a").each do |line|
      if line.to_html.match(/ncaab\/teams\//)
        abbrev = line.to_html.match(/ncaab\/teams\/(.*)\"/)[1]
        load(abbrev)
      end
    end
  end
end
