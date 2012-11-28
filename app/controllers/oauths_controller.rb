class OauthsController < ApplicationController
  def index
    @oauths = User.find(session[:user_id]).oauths 
  end

  def generate
  	token = SecureRandom.urlsafe_base64
    @outh = User.find(session[:user_id]).oauths.create(:token => token)
    flash[:notice] = "succesfully created token #{token}"
    redirect_to :back
  end
end
