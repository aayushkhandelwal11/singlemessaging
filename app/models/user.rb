class User < ActiveRecord::Base
  
  attr_accessible :age, :email, :name,:password,:password_confirmation,:avatar
  has_many:messages,:dependent => :destroy
  has_many:threadmessages,:dependent => :destroy
  validates_attachment :avatar, :presence => true, :content_type => { :content_type => "image/jpg" }
  validates :name, :presence=> true, :uniqueness => true
  validates :email, :presence=>true, :format => { :with => /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/ },:uniqueness => true  
  validates :age, :presence=> true, :format => { :with => /^[\d]+$/}
  validates_length_of :password, :minimum => 8
  has_attached_file :avatar ,:styles => {:small => "120*120>"}
  has_secure_password

end
