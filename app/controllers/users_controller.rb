class UsersController < ApplicationController

  skip_before_filter :authorize, only: [:create, :new, :user_verify, :send_password]
  skip_before_filter :authorize_through_json
  before_filter :check_user_not_loggedin, :only => [:user_verify]

  autocomplete :user, :name, :display_value => :name_with_email
  


  caches_action :user_verify, :layout => false


  def change_avatar
    @user = current_user
  end
  def change_time_zone
    @user = current_user
  end
  def change_notification
    @user = current_user
  end
  
  def user_verify
    @user = User.new
  end
  
  def send_password
   @user = User.find_by_name_and_email(params[:user][:name],params[:user][:email])
   if @user
      pass = SecureRandom.urlsafe_base64(n=6)
      @user.update_attributes({:password => pass})
      Notifier.send_password(@user,pass).deliver
   end   
   respond_to do |format|
     flash[:notice] = @user ? 'A mail has been sent to you' : "Your entry Doesn't match our record"
     format.html { redirect_to request.referrer }
   end 
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice]= "User #{@user.name} was successfully created."
        format.html { redirect_to login_path}
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def succesful_updation
     flash[:notice] = "User #{current_user.name} was successfully updated"
     redirect_to inbox_path 
  end  

  def update_notification
    current_user.update_attribute(:notification, params[:notification])
    succesful_updation
    
  end

  def update_time_zone
     current_user.update_attribute(:time_zone, params[:user][:time_zone])
     succesful_updation
  end
  
  def update_picture
    if params[:user] && current_user.update_attributes({:avatar => params[:user][:avatar]})
       succesful_updation
    else
       flash[:error] = params[:user] == nil ? "Please update a photo" : "Please update a photo of jpg/png type"
       redirect_to request.referrer   
    end
  end

  def update
     if current_user.authenticate(params[:user][:old])
       params[:user].delete :old
       if current_user.update_attributes(params[:user])
         succesful_updation
         return
       else
         flash[:error] = "Password is empty or doesnt matches"
       end
     else
         flash[:error] = "Old password doesn't match"
     end
     redirect_to edit_user_path(current_user.id)
   end
end
