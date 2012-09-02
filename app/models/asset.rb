class Asset < ActiveRecord::Base
  attr_accessible :document, :message_id
  
  belongs_to :message
  belongs_to :user
  
  has_attached_file :document

end
