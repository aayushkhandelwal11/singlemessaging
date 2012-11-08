class Receiver < ActiveRecord::Base
  
  attr_accessible :message_id, :user_id, :status, :read
  
  belongs_to :message
  belongs_to :user
  before_save :xyz
  def xyz
  	if user.notification == "1" && status == Message::MESSAGE_STATUS["AvailableBoth"]
      Notifier.delay.gmail_message(message.sender, user, "dfsdffs")
    end
  end


end
