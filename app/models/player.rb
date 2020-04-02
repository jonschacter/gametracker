class Player < ActiveRecord::Base
    has_many :game_sessions_players
    has_many :gamesessions, through: :game_sessions_players
end