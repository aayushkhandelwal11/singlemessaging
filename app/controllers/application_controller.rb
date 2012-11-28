class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize_through_json
  before_filter :authorize
  before_filter :set_prefered_language
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
  def authorize_through_json
    if params[:format] == "json"
      if params[:token].present?
        o = Oauth.find_by_token(params[:token]) 
        if o
          session[:user_id] = o.user_id
          session[:expiry_time] = 10.seconds.from_now
        else
          respond_to do |format|
            format.json { render :text => "error"  }
          end 
        end  
      end
    end  
  end
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_prefered_language
    I18n.locale = session[:locale] || I18n.default_locale
  end

end
