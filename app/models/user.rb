class User < ActiveRecord::Base
  attr_accessible :age, :email, :name, :password_digest, :time_zone
  attr_accessible :password, :password_confirmation, :avatar, :notification
  attr_accessible :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at
  
 
  has_many :messages, :dependent => :destroy
  has_many :flag_messages, :dependent => :destroy
  has_many :receivers, :dependent => :destroy
  has_many :authentications
  
  
  
  validates_attachment_size :avatar, :less_than=>1.megabyte, :message => "Image size too large"
  validates_attachment_content_type :avatar, :content_type=>['image/jpeg', 'image/png', 'image/gif', 'image/jpg'], :message => "Please upload a image of jpg/png format"
  validates :name, :presence => true,:length => { :minimum => 3,:tokenizer => lambda {|str| str.scan(/[a-z]/i)},:message => "Minimum 3 alphabets should be their "}
  validates :email, :uniqueness => {:case_sensitive => false}, :presence => true 
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :age, :numericality => {:only_integer => true ,:greater_than => 0 , :less_than => 100 },:allow_nil => true
  validates :password, :presence => true,:length => { :minimum => 6 }, :if => :password
  
  has_attached_file :avatar ,:styles => {:small => "120x120>",:thumb => "50x50>"}
  
  has_secure_password 
  

  after_create :welcome
 
  scope :join_with_receiver, joins("as u inner join receivers as r on r.user_id = u.id")
  
  def name_with_email
     user = User.find self.id
    "#{self.name}<#{user.email}>"
  end


  def apply_omniauth(omniauth)
    if omniauth['provider'] != 'twitter'
      self.email = omniauth['info']['email'] if email.blank?
    end  
    self.name  = omniauth['info']['name'] if name.blank?
    self.notification = "1"
    self.time_zone = "New Delhi"
    self.password = self.password_confirmation = self.name
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid']) 
  end

  def welcome
    Notifier.welcome_message(self).deliver
  end  

end
