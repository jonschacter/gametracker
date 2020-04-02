class GameSessionsPlayer < ActiveRecord::Base
    belongs_to :player
    belongs_to :gamesession
end