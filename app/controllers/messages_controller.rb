class MessagesController < ApplicationController
  autocomplete :user, :name
  
  def outbox
  @messages = Message.includes(:sender).ordering_by_updated_at.select("messages.id , sender_id , messages.updated_at , subject").sent.where("sender_id= ?",session[:user_id]).join_with_receiver.group("parent_id,messages.id").page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.json { render json: @messages }
    end
  end
  
  def edit_draft
    @message = Message.includes(:receivers).find(params[:id])
    session[:edit_message]=@message.id
  end
  
  def send_draft
    @message = Message.find(session[:edit_message])
    #@message1 = Message.new(params[:message])
    @message.content = params[:message][:content]
    @message.subject = params[:message][:subject]
    @message.assets = params[:message][:assets]
    @message.parent_id = 0
    @message.save
    @message.receivers.each do |receiver|
      if params[:commit]=="send"
        receiver.status="b"
      else
        receiver.status="d"
      end 
      receiver.save
    end
    respond_to do |format| 
      if params[:commit]!="send"
        format.html { redirect_to inbox_url, notice: 'Message was Saved in drafts' }
      else
        format.html { redirect_to inbox_url, notice: 'Message was Send' }
      end
      format.json { render json: @message, status: :created, location: @message }
    end
  end
  
  def index
    @messages=Message.includes(:sender,:receivers).ordering_by_updated_at.select("messages.id , sender_id , messages.updated_at , subject").sent.where("r.user_id =?",session[:user_id]).join_with_receiver.group("parent_id,messages.id").page(params[:page]).per(5)
     
    respond_to do |format|
      format.html 
      format.json { render json: @messages }
    end
  end
 
  def draft_index
    @messages=Message.includes(:sender).ordering_by_updated_at.select("messages.id,sender_id,messages.updated_at,subject").where("r.status='d' and sender_id =?",session[:user_id]).join_with_receiver.group("messages.id").page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.json { render json: @messages }
    end
  end
  def downloads
   @asset = Asset.find(params[:id])
 
     send_file @asset.document.path, :type => @asset.document_content_type
  
  end



  def flag
    @message=Message.find session[:message_id]
    if @message.parent_id!=0
      @message=Message.find @message.parent_id
    end
    count=0 
    if ! FlagMessage.find_by_user_id_and_message_id(session[:user_id],@message.id)
      count=1
      FlagMessage.create(:user_id =>session[:user_id],:message_id => @message.id)
      @message.reload
    end
    
    respond_to do |format|
      if @message.flagged
         format.html { redirect_to inbox_url, notice: 'U flagged it and it will no longer be available' }
      
      elsif count==1
        format.html { redirect_to request.referrer, notice: 'U flagged it' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { redirect_to request.referrer, notice: 'U have already flagged it ' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end 
  end
  
  
  def reply
    @message = Message.new(params[:message])
    @message.sender=User.find session[:user_id]
    parent_message=Message.find session[:message_id]
    if parent_message.parent_id!=0
      @message.parent_id=parent_message.parent_id
    else
      @message.parent_id=parent_message.id
    end 
    @message.save
    parentmessage=Message.find @message.parent_id
    parentmessage.updated_at=Time.now
    parentmessage.save
    array_of_user=[]
    if parentmessage.sender_id != session[:user_id]
       array_of_user=[parentmessage.sender_id]
    else
       array_of_user= Receiver.find_all_by_message_id(session[:message_id]).collect(&:user_id)
    end
    array_of_user.each do |num|
      @receiver = Receiver.new
      if params[:commit]=="send"
         @receiver.status="b"
         @receiver.read='false'
      else
         @receiver.status="d"
      end   
      @receiver.user=User.find (num)
      @receiver.message =@message
      if @receiver.save && @receiver.status == "b" 
         if @receiver.user.notification == "1"
           Notifier.gmail_message(@message.sender,@receiver.user).deliver   
         end
      end    
    end
    respond_to do |format|
      if @message.save
        format.html { redirect_to request.referrer, notice: 'Replied' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { redirect_to message_url, notice: 'Something went wrong' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def show
    @message = Message.find(params[:id])   
    session[:message_id]=params[:id]
    name=(User.find session[:user_id]).name
    if @message.parent_id!=0
      parentmessage=Message.find @message.parent_id
    else
      parentmessage=@message
    end  
    # changing the read 
    @receivers=Receiver.find_all_by_user_id(session[:user_id])
    @receivers.each do |receiver|
        if receiver.message.id = parentmessage.id ||receiver.message.parent_id=parentmessage.id 
           receiver.read=true;
           receiver.save
        end
    end
    if parentmessage.sender_id == session[:user_id]
       @sender=name
       @receiver=User.select("u.name").where("r.message_id= ?",params[:id]).join_with_receiver.collect(&:name).join(', ')
       
       @messages=Message.showing.where("(messages.id =? or parent_id =?) and (( sender_id=? and status in ('b','r')) or (sender_id !=? and status in ('b','s')))",parentmessage.id,parentmessage.id,session[:user_id],session[:user_id] ).join_with_receiver.group("messages.id").page(params[:page]).per(3)
    else
       @receiver=name
       @sender=@message.sender.name
       
       @messages=Message.showing.where(" (messages.id = ? or parent_id =?) and((sender_id=? and status in ('b','r')) or (sender_id=? and status in ('b','s')))",parentmessage.id,parentmessage.id, session[:user_id], @message.sender_id ).join_with_receiver.group("messages.id").page(params[:page]).per(3)
    end  
   
    respond_to do |format|
      @message=Message.new
       3.times { @message.assets.build}
      format.html
      format.json { render json: @messages }
    end
  end

  def new
    @message = Message.new
    3.times { @message.assets.build}
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  def create
    array_of_id=[] 
    count=0
    if params[:message][:sender_id].length>1 &&params[:message][:subject].length>1
      count=1
      array_of_user=params[:message][:sender_id].split(";")
      @message = Message.new(params[:message])
      @message.sender=User.find session[:user_id]
      @message.content=params[:message][:content]
      @message.parent_id=0
      @message.subject=params[:message][:subject]
      @message.save
      array_of_user.each do |num|
        @receiver = Receiver.new
          if params[:commit]=="send"
            @receiver.status="b"
            @receiver.read='false'
          else
            @receiver.status="d"
          end   
        @receiver.user=User.find_by_name(num)
        @receiver.message =@message
        if @receiver.save && @receiver.status == "b" 
          if @receiver.user.notification == "1"
            Notifier.gmail_message(@message.sender,@receiver.user).deliver   
          end
        end  
      
      end
    end  
    respond_to do |format|
      if  count==1 && @message.save
        if params[:commit]!="send"
            format.html { redirect_to inbox_url, notice: 'Message was Saved in drafts' }
        else
            format.html { redirect_to inbox_url, notice: 'Message was Send' }
        end
        format.json { render json: @message, status: :created, location: @message }
      elsif count==0
        if params[:message][:content].length<1
          format.html { redirect_to request.referrer, notice: 'Subject is empty' }
        else
          format.html { redirect_to request.referrer, notice: 'Mention atleast one recepent' }
        end  
        format.json { render json: @message.errors, status: :unprocessable_entity }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    if @message.sender_id == session[:user_id]
       receivers=Receiver.find_all_by_message_id(params[:id])
       receivers.each do |receiver|
         if receiver.status == "d"
            @message.destroy
            break;        
         elsif receiver.status="b"
             receiver.status="s"
             receiver.save
         elsif receiver.status="r"
             receiver.status="u"
             receiver.save
         end
       end          
   else
      receiver=Receiver.find_by_message_id_and_user_id(params[:id],session[:user_id])
      if receiver.status == "b"
          receiver.status="r"
      elsif receiver.status="s"
          receiver.status="u"
      end
      receiver.save          
   end
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.json { head :no_content }
    end
  end
end
