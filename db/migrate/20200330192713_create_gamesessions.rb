class CreateGamesessions < ActiveRecord::Migration
  def change
    create_table :game_sessions do |t|
        t.integer :game_id
        t.integer :winner_id
        t.string :date
    end
  end
end
