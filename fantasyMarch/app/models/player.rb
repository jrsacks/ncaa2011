class Player < ActiveRecord::Base
  def <=>(other)
    other.total <=> total
  end

  def games
    Score.where(:playerId => self.playerId).order(:gameId)
  end

  def total
    Score.where(:playerId => self.playerId).reduce(0) do |sum, score|
      sum + score.points
    end
  end
end
