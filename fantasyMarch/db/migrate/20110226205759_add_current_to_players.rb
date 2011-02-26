class AddCurrentToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :current, :boolean, :default => false
  end

  def self.down
    remove_column :players, :current
  end
end
