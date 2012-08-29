class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  skip_before_filter :authorize, only: [:create,:new]
  autocomplete :user, :name
  def index
    redirect_to mes_url
    #@users = User.all

    #respond_to do |format|
     
     # format.html # index.html.erb
      #format.json { render json: @users }
    #end
  end
  def change_avatar
    @user = User.find(session[:user_id])
  end
  def change_notification
    @user = User.find(session[:user_id])
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        Notifier.welcome_message(@user).deliver
        format.html { redirect_to users_url, notice: 'User #{user.name} was successfully created.' }
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
       if params[:user] !=nil
          if @user.update_attribute(:notification,params[:user][:notification])
            format.html { redirect_to users_url,notice: "User #{@user.name} was successfully updated." }
            format.json { head :no_content }
          end 
       else
       
         format.html { render action: "change_notification" }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end  
  end
  
  def update_picture
   @user = User.find(session[:user_id])
    respond_to do |format|
       if params[:user] !=nil
          if @user.update_attribute(:avatar,params[:user][:avatar])
            format.html { redirect_to users_url,notice: "User #{@user.name} was successfully updated." }
            format.json { head :no_content }
          end 
       else
       
         format.html { render action: "change_avatar" }
         format.json { render json: @user.errors, status: :unprocessable_entity }
       end
     end  
  end
  
  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(session[:user_id])
      
    respond_to do |format|
     if @user.authenticate(params[:user][:old])
        @user.password=params[:user][:password]
        @user.password_confirmation=params[:user][:password_confirmation]
        if @user.save
          format.html { redirect_to users_url,notice: "User #{@user.name} was successfully updated." }
          format.json { head :no_content }
        else
          format.html { redirect_to edit_user_path(@user.id),notice: "Password is empty or doesnt matches"  }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
     else
        format.html { redirect_to edit_user_path(@user.id) ,notice: "Old password does'nt match" }
   
     end  
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
