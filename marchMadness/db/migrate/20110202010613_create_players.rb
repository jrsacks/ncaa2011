class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :playerId
      t.string :name
      t.boolean :alive

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
