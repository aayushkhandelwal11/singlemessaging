class Threadmessage < ActiveRecord::Base
  attr_accessible :description, :status,:assets_attributes,:draft
  belongs_to :message
  belongs_to :user 
  has_many :assets, :dependent => :destroy, :autosave => true
  accepts_nested_attributes_for :assets , :reject_if => lambda {|a| a[:document].blank? }
  before_save :default_values
  def default_values
    self.draft ||= 0
  end
end
