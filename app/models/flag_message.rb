class FlagMessage < ActiveRecord::Base
  attr_accessible :message_id, :user_id

  belongs_to :message
  belongs_to :user
  
  after_save :change_flagged_status
  after_create :change_flagged_status
  after_destroy :change_flagged_status
  private 
   def change_flagged_status
     
      
     if FlagMessage.find_all_by_message_id(self.message_id).count > 1
       
       self.message.flagged=true
     else
       
       self.message.flagged=false
     end
     self.message.save
     messages = Message.find_all_by_parent_id(self.message.id)
     messages.each do |message|
         message.flagged=self.message.flagged
         message.save   
     end 
   end
  # We would need a callback here so that we can mark and unmark the message as flagged
end