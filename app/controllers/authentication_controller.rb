class AuthenticationController < ApplicationController
  skip_before_filter :authorize , :except => [:index, :destroy]
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
     omniauth = request.env["omniauth.auth"]
     authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
     if authentication && !current_user
       flash[:notice] = "Signed in successfully using #{omniauth['provider']}"
       session[:user_id] = authentication.user.id
       redirect_to inbox_url
     elsif current_user
     	if !authentication
           current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
           flash[:notice] = "Authentication successful"
           redirect_to authentication_index_url
        else
           flash[:error] = "Already linked"
           redirect_to authentication_index_url
        end 	
     else
       user = User.new
       user.apply_omniauth(omniauth)
       if user.email != nil && !User.find_by_email(user.email) && user.save 
         flash[:notice] = "User account created succesfully update your time zone"
         session[:user_id] = user.id
         redirect_to change_time_zone_users_url
       elsif User.find_by_email(user.email)
         flash[:notice] ="Already an account exist with #{user.email}"
         redirect_to login_url
       else
         flash[:notice] ="Third party does not provide some infos regarding you please fill it"
         session[:omniauth] = omniauth.except('extra')
         redirect_to authentication_fill_email_url
       end
     end
  end
  def fill_email 
     @user =User.new
  end
  
  def change_email
    @user = User.new
    @user.apply_omniauth(session[:omniauth])
    @user.email = params[:user][:email]
    respond_to do |format|
     if @user.save
         flash[:notice] = "User account created succesfully update your time zone"
         session[:user_id] = @user.id
         session[:omniauth] = nil
         format.html {redirect_to change_time_zone_users_url}
      else
         format.html { render action: "fill_email" }
      end
   end 
  end	


  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentication_index_url
  end
end
