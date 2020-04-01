class GameController < ApplicationController
    get '/games' do
        if Helpers.logged_in?(session)
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
        else
            redirect '/login'
        end
    end

    get '/games/new' do
        if Helpers.logged_in?(session)
            erb :"games/new"
        else
            redirect '/login'
        end
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
        @game = Game.find_by_id(params[:id])
        if Helpers.logged_in?(session) && @game.user == Helpers.current_user(session)
            erb :"games/show"
        else
            redirect '/login'
        end
    end

    get '/games/:id/edit' do
        @game = Game.find_by_id(params[:id])
        if Helpers.logged_in?(session) && @game.user == Helpers.current_user(session)
            erb :"games/edit"
        else
            redirect '/login'
        end
    end

    patch '/games/:id' do
        @game = Game.find_by_id(params[:id])
        @game.name = params[:game][:name]
        @game.gametype = params[:game][:type]
        @game.save
        redirect "/games/#{@game.id}"
    end

    delete '/games/:id' do
        @game = Game.find_by_id(params[:id])
        @game.delete
        redirect '/games'
    end
end