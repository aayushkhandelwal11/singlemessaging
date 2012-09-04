class User < ActiveRecord::Base
  attr_accessible :age, :email, :name, :password_digest
  attr_accessible :password, :password_confirmation, :avatar, :notification
  attr_accessible :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at
  
  
  has_many:messages, :dependent => :destroy
  has_many :flag_messages, :dependent => :destroy
  has_many :receivers, :dependent => :destroy
  
  
  
  
  #validates_attachment_size :avatar,:less_than => 4.megabytes,:message   => "is too big"
  validates_attachment :avatar, :presence => true
  validates :name, :uniqueness => {:case_sensitive => false}, :presence => true
  validates :email, :presence=>true, :format => { :with => /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/ },:uniqueness => true  
  validates :age, :presence=> true, :format => { :with => /^[\d]+$/}
  validates_length_of :password, :minimum => 8
  
 
  has_attached_file :avatar ,:styles => {:small => "120*120!"}
  
  has_secure_password
  
  
  scope :join_with_receiver, joins("as u inner join receivers as r on r.user_id = u.id")

end
