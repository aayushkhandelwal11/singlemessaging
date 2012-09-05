class FlagMessage < ActiveRecord::Base
  attr_accessible :message_id, :user_id

  belongs_to :message
  belongs_to :user
  
  after_save :change_flagged_status
  after_create :change_flagged_status
  before_destroy :change_flagged_status
  private 
   def change_flagged_status
     if FlagMessage.find_all_by_message_id(self.message_id).count > 1
      self.message.flagged = true
     else
       
       self.message.flagged = false
     end
     self.message.save
     Message.where('parent_id =?',self.message.id).update_all(:flagged => self.message.flagged)
   end
end
