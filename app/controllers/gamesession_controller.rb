class GameSessionController < ApplicationController
    get '/gamesessions' do
        if Helpers.logged_in?(session)
            @user = Helpers.current_user(session)
            @gamesessions = []
            GameSession.all.each do |gamesession|
                if gamesession.user.id == @user.id
                    @gamesessions << gamesession
                end
            end
            erb :"gamesessions/index"
        else
            redirect '/login'
        end
    end
end