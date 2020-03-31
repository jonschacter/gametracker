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
                if game.gametype == "board"
                    @boardgames << game
                elsif game.gametype == "video"
                    @videogames << game
                elsif game.gametype == "card"
                    @cardgames << game
                elsif game.gametype == "dice"
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
end