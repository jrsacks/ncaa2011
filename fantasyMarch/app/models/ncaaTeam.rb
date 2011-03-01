class Ncaateam
  def load(teamAbbrev)
    stringIo = open("http://rivals.yahoo.com/ncaa/basketball/teams/#{teamAbbrev}/roster")
    html = stringIo.read

    teamname = ''
    html.each do |line|
      if line.match(/<title>/)
        teamname =  (Nokogiri::HTML(line)/"title").inner_html.split(' -')[0]
      end
      if line.match(/\/ncaab\/players\/[0-9]+/) 
        idMatch = line.match(/[0-9]+/)
        fullname = (Nokogiri::HTML(line)/"a").inner_html.split(', ').reverse.join(' ')

        unless idMatch.nil?
          player = Player.find_or_create_by_playerId(:playerId => idMatch[0])
          player.name = fullname
          player.team = teamname
          player.alive = true
          player.save
        end
      end
    end
  end

  def all(teamStart)
    start = false
    start = true if teamStart.nil?

    doc = Nokogiri::HTML(open("http://rivals.yahoo.com/ncaa/basketball/teams"))
    doc.search("a").each do |line|
      if line.to_html.match(/ncaab\/teams\//)
        abbrev = line.to_html.match(/ncaab\/teams\/(.*)\"/)[1]
        Rails.logger.info abbrev
        start = true if abbrev == teamStart
        load(abbrev) if start
      end
    end
  end
end
