class Threadmessage < ActiveRecord::Base
  attr_accessible :description, :status
  belongs_to :message
  belongs_to :user 
end
