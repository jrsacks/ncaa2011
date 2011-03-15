class Player < ActiveRecord::Base
  def <=>(other)
    other.total <=> total
  end

  def games
    Score.find(:all, :conditions => {:playerId => self.playerId}, :order => :gameId)
  end

  def total
    Score.find(:all, :conditions => {:playerId => self.playerId}).reduce(0) do |sum, score|
      sum + score.points
    end
  end
end
