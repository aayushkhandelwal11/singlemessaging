class ThreadmessagesController < ApplicationController
  # GET /threadmessages
  # GET /threadmessages.json
  def index
    @threadmessages = Kaminari.paginate_array(Threadmessage.includes(:user).order("updated_at DESC").where('message_id = ? and draft=1',session[:message_id])).page(params[:page]).per(10)
    @count=Threadmessage.where('message_id=? and draft= 0 and user_id=?',session[:message_id],session[:user_id]).count
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @threadmessages }
    end
  end
  def draft_index
    @threadmessages = Kaminari.paginate_array(Threadmessage.includes(:user).order("updated_at DESC").where('message_id = ? and draft=0 and user_id = ?',session[:message_id],session[:user_id])).page(params[:page]).per(10)
    @count=@threadmessages.length
    respond_to do |format|
      format.html # draft_index.html.erb
      format.json { render json: @threadmessages }
    end
  end
  def addlink
    @asset=Asset.new
    redirect_to mes_url
    respond_to do |format|
      format.js # show.html.erb
     
    end
  end
  # GET /threadmessages/1
  # GET /threadmessages/1.json
  def show
    @threadmessage = Threadmessage.find(params[:id])
    if @threadmessage.user_id != session[:user_id] 
       @threadmessage.status='r'
       @threadmessage.save
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @threadmessage }
    end
  end

  # GET /threadmessages/new
  # GET /threadmessages/new.json
  def new
    array_of_id=session[:list_users]
    array_of_threadids=[]
    array_of_id.each do |messageid|
      @threadmessage = Threadmessage.new(params[:threadmessage])
      @threadmessage.status='r'
      @threadmessage.user=User.find session[:user_id]
      @threadmessage.message=Message.find messageid
      @threadmessage.save
      array_of_threadids.push(@threadmessage.id)
      4.times {@threadmessage.assets.build}
    end  
    @threadmessage.assets.build
    session[:list_users]=array_of_threadids
    #@threadmessage.assets.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @threadmessage }
    end
  end


  # DELETE /threadmessages/1
  # DELETE /threadmessages/1.json
  def destroy
    @threadmessage = Threadmessage.find(params[:id])
    @threadmessage.destroy

    respond_to do |format|
      format.html { redirect_to draft_index_url }
      format.json { head :no_content }
    end
  end
  def edit
    @threadmessage = Threadmessage.find(params[:id])
    session[:list_users]=[@threadmessage.id]
  end
  def update
    counter=0;
    array_of_id=session[:list_users]
    array_of_id.each do |threadid|
      @threadmessage = Threadmessage.find(threadid)
      @threadmessage.update_attributes(params[:threadmessage])
      @threadmessage.status='u'
      @threadmessage.draft=1
      if @threadmessage.save
         m=@threadmessage.message
         m.updated_at=@threadmessage.updated_at
         if @threadmessage.user != m.to_user
             user_send=m.to_user   
         else
            user_send=m.from_user
         end
         if user_send.notification == "1"
           Notifier.gmail_message(@threadmessage.user,user_send).deliver   
         end
         m.save
         counter=1
      end   
    end     
    respond_to do |format|
      if counter==1
        format.html { redirect_to mes_url, notice: 'Threadmessage was successfully created.' }
        format.json { render json: @threadmessage, status: :created, location: @threadmessage }
      else
        format.html { render action: "new" }
        format.json { render json: @threadmessage.errors, status: :unprocessable_entity }
      end
    end
  end  
end
