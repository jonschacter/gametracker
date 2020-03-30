class Player < ActiveRecord::Base
    has_and_belongs_to_many :game_sessions
end