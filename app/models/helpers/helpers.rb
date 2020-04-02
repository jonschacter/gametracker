class Helpers
    def self.logged_in?(session)
        !!session[:user_id]
    end

    def self.current_user(session)
        User.find(session[:user_id])
    end

    def self.valid_date?(date_string)
        y, m, d = date_string.split("-")
        if Date.valid_date?(y.to_i, m.to_i, d.to_i) && Date.parse(date_string) <= Date.current
            true
        else
            false
        end
    end
end