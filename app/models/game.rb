class Game < ActiveRecord::Base
    has_many :gamesessions
    belongs_to :user

    def my_winrate
        gamesessions = GameSession.where(game_id: self.id)
        my_wins = []
        gamesessions.each do |gamesession|
            if gamesession.winner.include?(Player.find_by(name: "Current User"))
                my_wins << gamesession
            end
        end
        percent = (my_wins.length.to_f / gamesessions.length.to_f * 100).round(2)
    end
end