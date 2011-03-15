class AddTeamToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :team, :string
  end

  def self.down
    remove_column :players, :team
  end
end
