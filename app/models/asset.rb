class Asset < ActiveRecord::Base
  attr_accessible :document, :threadmessage_id
  belongs_to :threadmessage
  has_attached_file :document
end
