class CreateGamesessionsPlayers < ActiveRecord::Migration
  def change
    create_table :gamesessions_players do |t|
        t.integer :gamesession_id
        t.integer :player_id
    end
  end
end
