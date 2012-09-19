class UsersController < ApplicationController

  skip_before_filter :authorize, only: [:create,:new,:user_verify,:send_password]
  
  autocomplete :user, :name
   
  def change_avatar
    @user = User.find(session[:user_id])
  end
  
  def change_notification
    @user = User.find(session[:user_id])
  end
  
  def user_verify
    @user = User.new
  end
  
  def send_password
   count = 0
   if User.find_by_name_and_email(params[:user][:name],params[:user][:email])
      @user = User.find_by_name params[:user][:name]
      pass = SecureRandom.urlsafe_base64(n=6)
      @user.password = pass
      @user.password_confirmation = pass
      @user.save
      Notifier.send_password(@user,pass).deliver
      count = 1 
   end   
   respond_to do |format|
     flash[:notice] = count == 1 ? 'A mail has been sent to you' : "Your entry Doesn't match our record"
     format.html { redirect_to request.referrer }
   end 
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        Notifier.welcome_message(@user).deliver
        flash[:notice]= "User #{@user.name} was successfully created."
        format.html { redirect_to login_path}
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_notification
    @user = User.find(session[:user_id])
    respond_to do |format|
      if params[:user] != nil && @user.update_attribute(:notification, params[:user][:notification])
        format.html { redirect_to inbox_path, notice: "User #{@user.name} was successfully updated" }
      else
        flash[:error] = "Something went wrong "
        format.html { render action: "change_notification" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end  
  end
  
  def update_picture
    @user = User.find(session[:user_id])
    respond_to do |format|
      if params[:user] && @user.update_attributes({:avatar => params[:user][:avatar]})
        format.html { redirect_to inbox_path , notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
       flash[:error] = params[:user] == nil ? "Please update a photo" : "Please update a photo of jpg/png type"
       format.html { redirect_to request.referrer}
       format.json { render json: @user.errors, status: :unprocessable_entity }    
       end
    end  
  end

  def update
    @user = User.find(session[:user_id])
    respond_to do |format|
     if @user.authenticate(params[:user][:old])
       @user.password = params[:user][:password]
       @user.password_confirmation = params[:user][:password_confirmation]
       if @user.save
         format.html { redirect_to inbox_path, notice: "User #{@user.name} was successfully updated." }
         format.json { head :no_content }
       else
         flash[:error] = "Password is empty or doesnt matches"
       end
     else
         flash[:error] = "Old password doesn't match"
     end
     format.html { redirect_to edit_user_path(@user.id)} 
   end
  end
end
