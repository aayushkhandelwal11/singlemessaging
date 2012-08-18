class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.includes(:to_user,:from_user,:threadmessages).order('updated_at DESC').find(:all,:conditions => ['(to_user_id=? and status in ("b","s")) or (from_user_id=? and status in ("b","r"))',session[:user_id],session[:user_id]])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /threadmessages
  # GET /threadmessages
  def show
    session[:message_id]=params[:id]
    redirect_to threadmessages_url
    @message = Message.find(params[:id])
     
    #respond_to do |format|
     # format.html # show.html.erb
      #format.json { render json: @message }
    #end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    @message.status='b'
    @message.from_user=User.find session[:user_id]

   
     respond_to do |format|
      if @message.save
        session[:message_id]=@message.id
        format.html { redirect_to new_threadmessage_path, notice: 'Message was successfully created. from #{params[:to_user]}' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json 

  def destroy
    @message = Message.find(params[:id])
    if @message.status=="b"
      if @message.to_user_id==session[:user_id]
         @message.status="r"
      else
         @message.status="u"  
      end
       @message.save 
    else
    			@message.destroy
    		   	
    end  
    

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
end
