class OauthsController < ApplicationController
   #caches_action :index , :cache_path => Proc.new { current_user }
  skip_before_filter :authorize_through_json
  def index
    @oauths = current_user.oauths 
  end

  def generate
  	#expire_action :action => :index #, :cache_path => Proc.new { current_user }
  	token = SecureRandom.urlsafe_base64
    @outh = current_user.oauths.create(:token => token)
    flash[:notice] = "succesfully created token #{token}"
    redirect_to inbox_url
  end
end
