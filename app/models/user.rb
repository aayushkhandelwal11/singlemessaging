class User < ActiveRecord::Base
  attr_accessible :age, :email, :name, :password_digest, :time_zone
  attr_accessible :password, :password_confirmation, :avatar, :notification
  attr_accessible :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at
  
  
  has_many:messages, :dependent => :destroy
  has_many :flag_messages, :dependent => :destroy
  has_many :receivers, :dependent => :destroy
  
  
  
  
  validates_attachment_size :avatar, :less_than=>1.megabyte, :message => "Image size too large"
  validates_attachment_content_type :avatar, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/jpg'], :message => "Please upload a image of jpg/png format"
  validates :name, :uniqueness => {:case_sensitive => false}, :presence => true
  validates :email, :uniqueness => {:case_sensitive => false}, :presence => true 
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :age, :presence=> true,:numericality => {:only_integer => true}
  validates :password, :presence     => true, :confirmation => true,:length => { :minimum => 6 }, :if => :password 
  
 
  has_attached_file :avatar ,:styles => {:small => "120*120>",:thumb => "50*50>"}
  
  has_secure_password
  
  
  scope :join_with_receiver, joins("as u inner join receivers as r on r.user_id = u.id")

end
