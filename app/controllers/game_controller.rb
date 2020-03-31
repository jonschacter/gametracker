class GameController < ApplicationController
    get '/games' do
        if Helpers.logged_in?(session)
            @user = Helpers.current_user(session)
            @games = Game.where(user_id: @user.id)
            erb :"games/index"
        else
            redirect '/login'
        end
    end
end