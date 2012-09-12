class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  before_filter :set_user_time_zone

  private

  def set_user_time_zone
    Time.zone = User.find(session[:user_id]).time_zone if session[:user_id]
  end
  
  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      session[:return_to] = request.fullpath
      redirect_to login_url, notice: "Please log in"
    end
  end
end
