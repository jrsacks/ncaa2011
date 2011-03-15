class Team < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :player0
  validates_presence_of :player1
  validates_presence_of :player2
  validates_presence_of :player3
  validates_presence_of :player4
  validates_presence_of :player5
  validates_presence_of :player6
  validates_presence_of :player7
  validates_presence_of :player8
  validates_presence_of :player9
  
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
