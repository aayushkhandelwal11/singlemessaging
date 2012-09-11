class SessionsController < ApplicationController
  skip_before_filter :authorize
  def new
 
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])

      session[:user_id] = user.id
      redirect_to inbox_path
    else
     flash[:error]= "Invalid email/password combination"
      redirect_to login_path 
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Logged out"
  end
end
