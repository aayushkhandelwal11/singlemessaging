class Message < ActiveRecord::Base
  attr_accessible :status,:from_user_id,:to_user_id,:to_user
  has_many :threadmessages,:dependent => :destroy
  belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
  belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"
  validates :to_user_id, :presence=> true
end
