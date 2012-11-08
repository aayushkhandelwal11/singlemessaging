class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  before_filter :set_user_time_zone
  helper_method :current_user
  private

  def set_user_time_zone
    Time.zone = User.find(session[:user_id]).time_zone if session[:user_id]
  end
  
  protected

  def authorize
    if cookies[:user_id] && session[:user_id] == nil 
      session[:user_id] = cookies[:user_id]
    end  
    unless User.find_by_id(session[:user_id]) || User.find_by_id(cookies[:user_id])
      session[:return_to] = request.fullpath
      flash[:error] = "Please Log in"
      redirect_to login_url
    end
  end
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    
  end

end
