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

    post '/gamesessions/new' do
        if params[:game][:name] == "New"
            @game = Game.new(name: params[:new_game][:name])
            @game.gametype = params[:new_game][:type]
            @game.user_id = Helpers.current_user(session).id
            @game.save 
        else
            @game = Game.find_by(name: params[:game][:name], user_id: Helpers.current_user(session).id)
        end

        @players = []
        params[:gamesession][:players].each do |player|
            if player == "Me"
                @players << Player.find_or_create_by(name: "Current User")
            elsif player != ""
                @players << Player.find_or_create_by(name: player)
            end
        end

        @winner = @players[params[:gamesession][:winner].to_i - 1]
        
        @gamesession = GameSession.new
        @gamesession.date = params[:gamesession][:date]
        @gamesession.game = @game
        @gamesession.players = @players
        @gamesession.winner = @winner
        @gamesession.save

        redirect "/gamesessions/#{@gamesession.id}"
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