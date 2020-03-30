class CreateGamesessions < ActiveRecord::Migration
  def change
    create_table :gamesessions do |t|
        t.integer :game_id
        t.integer :winner_id
        t.string :date
    end
  end
end
