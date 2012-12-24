 class SessionsController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :authorize_through_json
  
  caches_page :faq
  before_filter :check_user_not_loggedin, :only => [:new]

  def new
    respond_to do |format|
      format.html 
      format.json { render :text => "Need to log in"  }
    end
  end
  def faq
  end
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:user_id] = user.id
      end
      session[:user_id] = user.id
      url = session[:return_to] || inbox_path
      session[:return_to] = nil
      url = inbox_path if url.eql?('/logout')
      redirect_to(url)
    else
     #flash[:error] = "Invalid email/password combination"
     flash[:error] = t('flash.error.invalid_log_in')
      redirect_to login_path 
    end
  end


  def destroy
    cookies.delete(:user_id)
    reset_session
    redirect_to login_path, notice: "Logged out"
  end
end

