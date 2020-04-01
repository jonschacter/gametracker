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

    get '/gamesessions/new' do
        if Helpers.logged_in?(session)
            @user = Helpers.current_user(session)
            @games = Game.where(user_id: @user.id)
            erb :"gamesessions/new"
        else
            redirect '/login'
        end
    end

    get '/gamesessions/:id' do
        @gamesession = GameSession.find_by_id(params[:id])
        if Helpers.logged_in?(session) && @gamesession.user == Helpers.current_user(session)
            erb :"gamesessions/show"
        else
            redirect '/login'
        end
    end
end