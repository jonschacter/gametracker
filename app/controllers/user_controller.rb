class UserController < ApplicationController
    get "/signup" do
        if Helpers.logged_in?(session)
            redirect "/home"
        end
        erb :"users/signup"
    end

    post "/signup" do
        if params[:first_name] == "" || params[:last_name] == "" || params[:email] == "" || params[:password] == ""
            flash[:error] = "Please fill out all fields and try again"
            redirect "/signup"
        elsif User.find_by(email: params[:email])
            flash[:error] = "That email address already has an account, please log-in or try a different email"
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
        else
            flash[:error] = "Incorrect password, please try again"
            redirect "/login"
        end
    end
    
    get "/logout" do
        session.clear
        redirect "/login"
    end

    get "/home" do
        redirect_if_not_logged_in
        @user = Helpers.current_user(session)
        erb :"users/home"
    end
end