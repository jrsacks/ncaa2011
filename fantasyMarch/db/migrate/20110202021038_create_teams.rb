class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name
      t.integer :player0
      t.integer :player1
      t.integer :player2
      t.integer :player3
      t.integer :player4
      t.integer :player5
      t.integer :player6
      t.integer :player7
      t.integer :player8
      t.integer :player9

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
