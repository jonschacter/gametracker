class UserController < ApplicationController
    get "/signup" do
        if Helpers.logged_in?(session)
            redirect "/home"
        end
        erb :"users/signup"
    end

    post "/signup" do
        if params[:first_name] == "" || params[:last_name] == "" || params[:email] == "" || params[:password] == "" || User.find_by(email: params[:email])
            redirect "/signup"
        else
            user = User.create(first_name: params[:first_name].capitalize, last_name: params[:last_name].capitalize, email: params[:email], password: params[:password])
            session[:user_id] = user.id
            redirect "/home"
        end
    end

    get "/login" do
        if Helpers.logged_in?(session)
            redirect "/home"
        end
        erb :"users/login"
    end

    post "/login" do
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect "/home"
        end
        redirect "/login"
    end
    
    get "/logout" do
        session.clear
        redirect "/login"
    end

    get "/home" do
        if Helpers.logged_in?(session)
            @user = Helpers.current_user(session)
            erb :"users/home"
        else
            redirect "/login"
        end
    end
end