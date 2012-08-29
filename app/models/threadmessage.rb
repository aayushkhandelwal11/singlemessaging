class Threadmessage < ActiveRecord::Base
  attr_accessible :description, :status
  belongs_to :message
  belongs_to :user 
  has_many :assets,:dependent => :destroy
  accepts_nested_attributes_for :assets
  before_save :default_values
  def default_values
    self.draft ||= 0
  end
end
