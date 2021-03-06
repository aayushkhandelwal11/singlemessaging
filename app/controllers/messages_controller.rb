class MessagesController < ApplicationController
 
  skip_before_filter :authorize_through_json, :except => [:inbox, :destroy, :create]
  autocomplete :user, :name, :display_value => :name_with_email
  protect_from_forgery :except => :destroy
  def outbox
    @messages = Message.outbox(current_user).page(params[:page]).per(10)
    
  end
  
  def edit
    @message = Message.includes(:receivers).find(params[:id])
    if @message.sender != current_user
       flash[:notice]= 'You are not authorized for this' 
       redirect_to inbox_path
    end
    session[:edit_message] = params[:id]
    @receivers = []
    @message.receivers.each do |receiver|
      @receivers << receiver.user.name
    end
    @receivers = @receivers.join(', ') 
  end
  
  def send_draft
    @message = Message.find(session[:edit_message])
    if @message.sender != current_user
       flash[:notice]= 'You are not authorized for this' 
       redirect_to inbox_path 
    end
    @message.content = params[:message][:content]
    @message.created_at=Time.now
    @message.save
    @message.receivers.each do |receiver|
      if params[:commit] == "send"
        receiver.status = Message::MESSAGE_STATUS["AvailableBoth"]
      else
        receiver.status = Message::MESSAGE_STATUS["Draft"]
      end 
      receiver.save
    end

    respond_to do |format| 
      if params[:commit] != "send"
        format.html { redirect_to inbox_path, notice: 'Message was Saved in drafts' }
      else
        format.html { redirect_to inbox_path, notice: 'Message was Sent' }
      end
      format.json { render json: @message, status: :created, location: @message }
    end

  end
  
  def inbox
    #@messages = Message.inbox(current_user).search params[:search] 
    @messages = Message.inbox(current_user).page(params[:page]).per(10)
    respond_to do |format|
      format.html 
      format.json { render json: @messages }
    end
  end
 
  def drafts
    @messages = Message.drafts(current_user).page(params[:page]).per(10)
  end
  
  def downloads
    @asset = Asset.find(params[:id])
    send_file @asset.document.path, :type => @asset.document_content_type
  end

  def flag
    @message = Message.find session[:message_id]
    count = 0 
    if ! FlagMessage.find_by_user_id_and_message_id(current_user.id, @message.id)
      count = 1
      FlagMessage.create(:user_id => current_user.id, :message_id => @message.id)
    end
    respond_to do |format|
     if  count == 1
        format.html { redirect_to inbox_path, notice: 'You flagged it' }
        format.json { render json: @message, status: :created, location: @message }
     else
        flash[:error] = 'You have already flagged it '
        format.html { redirect_to request.referrer }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end 
  end
  
  
  def reply
    @message = Message.new(params[:message])
    @message.sender = current_user
    @message.parent_id = session[:message_id]
    parentmessage = Message.find @message.parent_id
    parentmessage.touch
    @message.subject=parentmessage.subject
    @message.save
    array_of_user = []
    if parentmessage.sender != current_user
       array_of_user = [parentmessage.sender_id]
    else
       array_of_user = Receiver.find_all_by_message_id(session[:message_id]).collect(&:user_id)
    end
    create_receivers(array_of_user,@message,"reply")
    respond_to do |format|
       if @message.save
         flash[:notice] = params[:commit] != "send" ? 'Message was Saved in drafts' : "Message was Sent " 
         format.html { redirect_to inbox_path }
         format.json { render json: @message, status: :created, location: @message }
       else
         flash[:error] = 'Something went wrong '
         format.html { redirect_to message_path }
         format.json { render json: @message.errors, status: :unprocessable_entity }
       end
    end
  end
  

  def show
    message = Message.find (params[:id])  
    if !(message.sender_id == current_user.id) && !(message.receivers.exists?( :user_id => current_user.id)) 
       flash[:error] = "you are not authorized to view this "
       redirect_to inbox_url 
       return
    end  
    parentmessage = Message.find message.parent_id
    session[:message_id] = parentmessage.id
    @sender = parentmessage.sender.name
    @subject = parentmessage.subject
    # changing the read 

    if message.receivers.where("user_id = ?",current_user.id).where(:read => false).update_all(:read => true ) > 0 
      flash.notice = "expired"
      expire_fragment("inbox_#{current_user.id}_#{Message.inbox(current_user).first.updated_at}")
    end
    if parentmessage.sender == current_user
       @receiver = User.select("u.name").where("r.message_id= ?",parentmessage.id).join_with_receiver.collect(&:name).join(', ')
       @messages = Message.showing_to_sender(parentmessage,parentmessage.sender)
    
    else

       @receiver = current_user.name
       @messages = Message.showing_to_receiver(parentmessage,parentmessage.sender,current_user)
    end  
    @message = Message.new
    @message.assets.build
  end

  def new
    @message = Message.new
    @message.assets.build
  end

  def create_receivers(array_of_users,message,received)
    count =0
    array_of_users.each do |num|
      @receiver = Receiver.new
      if params[:commit] == "send"
        @receiver.status = Message::MESSAGE_STATUS["AvailableBoth"]
        @receiver.read = 'false'
      else
        @receiver.status = Message::MESSAGE_STATUS["Draft"]
      end   
      if received != "reply"
        @receiver.user = User.find_by_email(num)
        
      else
        @receiver.user = User.find(num) 
      end  
        @receiver.message = message
        
      if @receiver.user == nil
         count+=1
      else
         @receiver.save
      end  
    end
    count    
  end

  def create

    array_of_user = [] 
    count = 0
    wrong_users = 0
    @message = Message.new(params[:message])
    if params[:message][:sender_id].length > 1 && params[:message][:subject].length > 1
      count = 1
      temporary = params[:message][:sender_id].split(">;")
      temporary.each do |val|
        array_of_user << val.split('<')[1]
      end
      array_of_user.uniq!
      
      @message.sender = current_user
      @message.save
      @message.update_attribute(:parent_id , @message.id)
      wrong_users = create_receivers(array_of_user, @message, "create")
    end  
    
    respond_to do |format|
      if  count == 1 && @message.save && @message.receivers.count != 0
        if wrong_users > 0
          flash[:alert]= "#{wrong_users} of the recipeients doesn't exists"
        end
        flash[:notice] = params[:commit] != "send" ? 'Message was Saved in drafts' : "Message was Sent "
        format.html { redirect_to inbox_path }
        format.json { render :text => flash[:notice] }
      elsif count == 0
         flash.now[:error] = params[:message][:subject].length < 1 ? 'Subject is empty' : 'Mention atleast one recepent'
         format.html { render action: "new" }
         format.json { render :json => flash.now[:error], :status => 406 }
      elsif @message.receivers.count == 0
         @message.destroy
         @message = Message.new(params[:message])
         flash.now[:error] = 'Invalid receiver'
         format.html { render action: "new" }
         format.json { render :json => flash.now[:error], :status => 406 }
      else
         format.html { render :text => "something went wrong"  }
         format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def index_delete
     @messages = Message.find(params[:message_ids])
     expire_fragment("inbox_#{current_user.id}_#{Message.inbox(current_user).first.updated_at}")
     @messages.each do |message|

        childmessages = Message.find_all_by_parent_id(message.parent_id)   
        childmessages.each do |childmessage|
         update_receivers(childmessage)
        end
     end  
     respond_to do |format|
       format.html { redirect_to request.referrer,:notice => "Selected Messages Deleted"}
     end
  end 
  

  def show_delete
     @messages = Message.find(params[:message_ids])
     @messages.each do |message|
        update_receivers(message)
     end  
     respond_to do |format|
       format.html { redirect_to request.referrer,:notice => "Selected Messages Deleted"}
     end
  end

  def update_receivers(message)
    if message.sender == current_user
       receivers=Receiver.find_all_by_message_id(message.id)
         receivers.each do |receiver|
         if receiver.status == Message::MESSAGE_STATUS["Draft"]
            message.destroy
            break;        
         elsif receiver.user_id == message.sender_id || receiver.status == Message::MESSAGE_STATUS["ReceiverDelete"]
             receiver.status = Message::MESSAGE_STATUS["BothDelete"]
             receiver.save   
         elsif receiver.status == Message::MESSAGE_STATUS["AvailableBoth"]
             receiver.status = Message::MESSAGE_STATUS["SenderDelete"]
             receiver.save
      
         end
       end          
    else
      receiver=Receiver.find_by_message_id_and_user_id(message.id,current_user.id)
      if receiver.status == Message::MESSAGE_STATUS["AvailableBoth"]
          receiver.status = Message::MESSAGE_STATUS["ReceiverDelete"]
      elsif receiver.status == Message::MESSAGE_STATUS["SenderDelete"]
          receiver.status = Message::MESSAGE_STATUS["BothDelete"]
      end
      receiver.save          
    end
  end  
  
  def destroy
    @message = Message.find(params[:id])
    update_receivers(@message)
    respond_to do |format|
      expire_fragment("inbox_#{current_user.id}_#{Message.inbox(current_user).first.updated_at}")
      format.html { redirect_to request.referrer }
      format.json { head :no_content }
    end
  end
end
