class GameController < ApplicationController
    
    get '/games' do
        redirect_if_not_logged_in
        @user = Helpers.current_user(session)
        @games = Game.where(user_id: @user.id)
        @boardgames = []
        @videogames = []
        @cardgames = []
        @dicegames = []
        @othergames = []
        @games.each do |game|
            if game.gametype == "Board"
                @boardgames << game
            elsif game.gametype == "Video"
                @videogames << game
            elsif game.gametype == "Card"
                @cardgames << game
            elsif game.gametype == "Dice"
                @dicegames << game
            else
                @othergames << game
            end
        end
        erb :"games/index"
    end

    get '/games/new' do
        redirect_if_not_logged_in
        erb :"games/new"
    end

    post '/games' do
        @game = Game.new
        @game.name = params[:game][:name]
        @game.gametype = params[:game][:type]
        @game.user = Helpers.current_user(session)
        @game.save
        redirect '/games'
    end

    get '/games/:id' do
        redirect_if_not_logged_in
        @game = Game.find_by_id(params[:id])
        if matching_user?(@game)
            @gamesessions = GameSession.where(game_id: @game.id)
            erb :"games/show"
        else
            redirect '/games'
        end
    end

    get '/games/:id/edit' do
        redirect_if_not_logged_in
        @game = Game.find_by_id(params[:id])
        if matching_user?(@game)
            erb :"games/edit"
        else
            redirect '/games'
        end
    end

    patch '/games/:id' do
        @game = Game.find_by_id(params[:id])
        @game.name = params[:game][:name]
        @game.gametype = params[:game][:type]
        @game.save
        redirect "/games/#{@game.id}"
    end
end