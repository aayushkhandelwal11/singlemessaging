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
      pass = SecureRandom.urlsafe_base64
      @user.password = pass
      @user.password_confirmation = pass
      @user.save
      Notifier.send_password(@user,pass).deliver
      count = 1 
   end   
   respond_to do |format|
    if count == 1
      format.html { redirect_to request.referrer, notice: 'A mail has been sent to you' }
    else
      format.html { redirect_to request.referrer, notice: "Your entry Doesn't match our record" }
    end
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
        format.html { redirect_to login_url, notice: "User #{@user.name} was successfully created." }
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
        format.html { redirect_to inbox_url, notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "change_notification", notice: "Somethong went wrong ."  }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end  
  end
  
  def update_picture
    @user = User.find(session[:user_id])
    respond_to do |format|
      if params[:user] != nil &&  @user.update_attribute(:avatar,params[:user][:avatar])
        format.html { redirect_to inbox_url,notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else 
        format.html { render action: "change_avatar" }
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
         format.html { redirect_to inbox_url, notice: "User #{@user.name} was successfully updated." }
         format.json { head :no_content }
       else
         format.html { redirect_to edit_user_path(@user.id), notice: "Password is empty or doesnt matches"  }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     else
         format.html { redirect_to edit_user_path(@user.id), notice: "Old password does'nt match" } 
     end  
   end
  end
end
