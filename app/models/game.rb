class Game < ActiveRecord::Base
    has_many :gamesessions
    belongs_to :user
end