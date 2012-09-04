class Message < ActiveRecord::Base
  attr_accessible :content , :sender_id, :subject, :assets_attributes, :flagged
  
  
  has_many :assets, :dependent => :destroy, :autosave => true
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  has_many :receivers, :dependent => :destroy
  belongs_to :parent, :class_name => "Message", :foreign_key => "parent_id"
  has_many :flag_messages, :dependent => :destroy
  MESSAGE_STATUS = { "Draft" => 0,"BothDelete" => 4, "AvailableBoth"=>1,"SenderDelete" => 2,
           "ReceiverDelete" => 3          
         }
  
  accepts_nested_attributes_for :assets , :reject_if => lambda {|a| a[:document].blank? }
  
  
  validates :sender_id, :presence=> true
   where(name: name) unless name.nil? }
  scope :inbox, lambda{ |user| includes(:sender,:receivers).order('messages.updated_at DESC').select("messages.id , sender_id , messages.updated_at , subject").where("r.user_id =? and r.status != ?",user.id,MESSAGE_STATUS["Draft"]).joins("inner join receivers as r on r.message_id =messages.id").group("parent_id") }
  
  scope :outbox, lambda{ |user| includes(:sender,:receivers).order('messages.updated_at DESC').select("messages.id , sender_id , messages.updated_at , subject").where("sender_id =? and r.status != ?",user.id,MESSAGE_STATUS["Draft"]).joins("inner join receivers as r on r.message_id =messages.id").group("parent_id") }
  
  scope :drafts, lambda{ |user| includes(:sender,:receivers).order('messages.updated_at DESC').select("messages.id , sender_id , messages.updated_at , subject").where("sender_id =? and r.status != ?",user.id,MESSAGE_STATUS["Draft"]).joins("inner join receivers as r on r.message_id =messages.id").group("parent_id") }

 # scope :listing, order('messages.updated_at DESC').select("messages.id , sender_id , messages.updated_at , subject")

  scope :showing, includes(:sender,:assets).order('messages.created_at DESC').select(" messages.id , sender_id , messages.created_at , content , subject ")

  #scope :sent, where('r.status !="d"')

  #scope :join_with_receiver, joins("inner join receivers as r on r.message_id =messages.id")
  
  
  default_scope where( :flagged => false) 
  
end
