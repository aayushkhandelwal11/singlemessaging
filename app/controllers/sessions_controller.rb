class SessionsController < ApplicationController
  skip_before_filter :authorize
  def new
 
  end

  def create
  #fix: find_by_name, find_by_attribute are called dynamic finders. read about dynamic finders and how they work
    user = User.find_by_name(params[:name])
    #redirect_to login_url, alert: "Invalid user/password combination"
    
    if user && user.authenticate(params[:password])

      session[:user_id] = user.id
      redirect_to inbox_url
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  def destroy
    reset_session
    redirect_to login_url, notice: "Logged out"
  end
end
