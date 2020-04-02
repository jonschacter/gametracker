require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "super-secret-game-tracking-system"
  end

  get "/" do
    erb :welcome
  end

  def redirect_if_not_logged_in
    if !Helpers.logged_in?(session)
        redirect '/login'
    end
  end

  def matching_user?(object)
    object.user == Helpers.current_user(session)
  end
end
