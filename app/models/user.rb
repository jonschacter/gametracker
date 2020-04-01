class User < ActiveRecord::Base
    has_many :games
    has_many :gamesessions, through: :games
    has_secure_password

    def fullname
        "#{self.first_name} #{self.last_name}"
    end
end