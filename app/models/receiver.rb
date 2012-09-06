class Receiver < ActiveRecord::Base
  
  attr_accessible :message_id, :user_id,:status,:read
  
  belongs_to :message
  belongs_to :user

end
