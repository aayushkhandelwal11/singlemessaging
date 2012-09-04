class Message < ActiveRecord::Base
  attr_accessible :content , :sender_id, :subject, :assets_attributes, :flagged
  
  
  has_many :assets, :dependent => :destroy, :autosave => true
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  has_many :receivers, :dependent => :destroy
  belongs_to :parent, :class_name => "Message", :foreign_key => "parent_id"
  has_many :flag_messages, :dependent => :destroy
  
  
  accepts_nested_attributes_for :assets , :reject_if => lambda {|a| a[:document].blank? }
  
  
  validates :sender_id, :presence=> true

  #scope :find_related_message
  scope :listing, order('messages.updated_at DESC').select("messages.id , sender_id , messages.updated_at , subject")
  scope :showing, includes(:sender,:assets).order('messages.created_at DESC').select(" messages.id , sender_id , messages.created_at , content , subject ")
  scope :sent, where('r.status !="d"')
  #scope :isparent, where('parent_id = 0')
  scope :join_with_receiver, joins("inner join receivers as r on r.message_id =messages.id")
  
  
  default_scope where( :flagged => false) 
  #  we don't need this, may we can have a boolean field called flagged. so that we can us this flagged field for selecting messages for inbox. And we can also add a scope/default scope for the same.
  
  
end
