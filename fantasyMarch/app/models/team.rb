class Team < ActiveRecord::Base
  def <=>(other)
    other.total <=> total
  end

  def players
    [
      Player.find_by_playerId(self.player0),
      Player.find_by_playerId(self.player1),
      Player.find_by_playerId(self.player2),
      Player.find_by_playerId(self.player3),
      Player.find_by_playerId(self.player4),
      Player.find_by_playerId(self.player5),
      Player.find_by_playerId(self.player6),
      Player.find_by_playerId(self.player7),
      Player.find_by_playerId(self.player8),
      Player.find_by_playerId(self.player9)
    ]
  end

  def total
    players.reduce(0) do |sum, player|
      sum + player.total
    end
  end
end
