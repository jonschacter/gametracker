class GameSession < ActiveRecord::Base
    belongs_to :game
    has_one :user, through: :game
    has_and_belongs_to_many :players

    def format_date
        all_months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        datearray = self.date.split("-")
        year = datearray[0]
        month = all_months[datearray[1].to_i - 1]
        day = datearray[2].to_i.to_s
        "#{month} #{day}, #{year}"
    end

    def winner=(winner_obj)
        self.winner_id = winner_obj.id
        self.save 
    end

    def winner
        Player.find_by_id(self.winner_id)
    end
end