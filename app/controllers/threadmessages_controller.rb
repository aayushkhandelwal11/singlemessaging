class ThreadmessagesController < ApplicationController
  # GET /threadmessages
  # GET /threadmessages.json
  def index
    @threadmessages = Kaminari.paginate_array(Threadmessage.includes(:user).order("updated_at DESC").find_all_by_message_id(session[:message_id])).page(params[:page]).per(10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @threadmessages }
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
    @threadmessage = Threadmessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @threadmessage }
    end
  end


  # POST /threadmessages
  # POST /threadmessages.json
  def create
    counter=0;
    array_of_id=session[:list_users]
    array_of_id.each do |messageid|
      @threadmessage = Threadmessage.new(params[:threadmessage])
      @threadmessage.status='u'
      @threadmessage.user=User.find session[:user_id]
      @threadmessage.message=Message.find messageid
      if @threadmessage.save
         m=Message.find messageid
         m.updated_at=@threadmessage.updated_at
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

  # DELETE /threadmessages/1
  # DELETE /threadmessages/1.json
  def destroy
    @threadmessage = Threadmessage.find(params[:id])
    @threadmessage.destroy

    respond_to do |format|
      format.html { redirect_to threadmessages_url }
      format.json { head :no_content }
    end
  end
end
