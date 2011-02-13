class Team < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true
  validates :player0, :presence => true
  validates :player1, :presence => true
  validates :player2, :presence => true
  validates :player3, :presence => true
  validates :player4, :presence => true
  validates :player5, :presence => true
  validates :player6, :presence => true
  validates :player7, :presence => true
  validates :player8, :presence => true
  validates :player9, :presence => true
  
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
