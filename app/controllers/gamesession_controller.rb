class GameSessionController < ApplicationController
    get '/gamesessions' do
        redirect_if_not_logged_in
        @user = Helpers.current_user(session)
        @gamesessions = []
        GameSession.all.each do |gamesession|
            if gamesession.user.id == @user.id
                @gamesessions << gamesession
            end
        end
        erb :"gamesessions/index"
    end

    get '/gamesessions/new' do
        redirect_if_not_logged_in
        @user = Helpers.current_user(session)
        @games = Game.where(user_id: @user.id)
        erb :"gamesessions/new"
    end

    post '/gamesessions/new' do
        if !Helpers.valid_date?(params[:gamesession][:date])
            redirect '/gamesessions/new'
        end
            
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

        @winners=[]
        if params[:gamesession][:winners]
            params[:gamesession][:winners].each do |winner_num|
                @winners << @players[winner_num.to_i - 1]
            end
        end

        @gamesession = GameSession.new
        @gamesession.date = params[:gamesession][:date]
        @gamesession.game = @game
        @gamesession.players = @players
        @gamesession.save
        @gamesession.winner = @winners

        redirect "/gamesessions/#{@gamesession.id}"
    end

    get '/gamesessions/:id' do
        redirect_if_not_logged_in
        @gamesession = GameSession.find_by_id(params[:id])
        if matching_user?(@gamesession)
            erb :"gamesessions/show"
        else
            redirect '/gamesessions/'
        end
    end

    get '/gamesessions/:id/edit' do
        redirect_if_not_logged_in
        @gamesession = GameSession.find_by_id(params[:id])
        if matching_user?(@gamesession)
            @user = Helpers.current_user(session)
            @user_player = Player.find_by(name: "Current User")
            @games = Game.where(user_id: @user.id)
            erb :"gamesessions/edit"
        else
            redirect '/gamesessions'
        end
    end

    patch '/gamesessions/:id' do
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

        @winners=[]
        if params[:gamesession][:winners]
            params[:gamesession][:winners].each do |winner_num|
                @winners << @players[winner_num.to_i - 1]
            end
        end

        @gamesession = GameSession.find_by_id(params[:id])
        @gamesession.date = params[:gamesession][:date]
        @gamesession.game = @game
        @gamesession.players = @players
        @gamesession.save
        @gamesession.winner = @winners

        redirect "/gamesessions/#{@gamesession.id}"
    end

    delete '/gamesessions/:id' do
        redirect_if_not_logged_in
        @gamesession = GameSession.find_by_id(params[:id])
        if matching_user?(@gamesession)
            @gamesession.delete
        end
        redirect '/gamesessions'
    end
end