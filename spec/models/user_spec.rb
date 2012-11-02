require 'spec_helper'
module UserSpecHelper
  def valid_user_attributes
    { :name => "aayush",
      :email => "aayush.khandelwal@vinsol.com",
      :password => "aayush11",
      :password_confirmation => "aayush11",
      :avatar_file_name => "390550_2061284230599_1911003160_n.jpg",
      :avatar_content_type => "image/jpeg",
      :avatar_file_size => 17185,
      :avatar_updated_at => Time.now
    }
  end
end
describe User do
  include UserSpecHelper	
  before(:each) do
    @user = User.new
  end
  
  it "name should not be nil" do
    @user.attributes = valid_user_attributes.except(:name)
    @user.should have(1).error_on(:name)
  end
  it "Valid name"do
    @user.attributes = valid_user_attributes.only(:name)
    @user.should have(0).error_on(:name)
  end
  it "Email should not be null and same" do
    @user.attributes = valid_user_attributes.except(:email)
    @user.should have(2).error_on(:email)
  end
  it "Valid Email"do
    @user.attributes = valid_user_attributes.only(:email)
    @user.should have(0).error_on(:email)
  end
  it "Invalid Password short of length "do
    @user.attributes = valid_user_attributes.with(:password=>"wer")
    @user.should have(2).error_on(:password)
  end
  it "Password not matching cinfirmation"do
    @user.attributes = valid_user_attributes.with(:password=>"qwertyuiop")
    @user.should have(1).error_on(:password)
  end
  it "Avatar should not be nill"do
    @user.avatar=nil
    @user.should have(1).error_on(:avatar)
  end
  it "should be valid" do
#    @user.name = "aayush"
#    @user.email = "aayush.khandelwal@vinsol.com"
#    @user.age = 22
#    @user.password = "aayush11"
#    @user.password_confirmation = "aayush11"
#    @user.avatar_file_name = "390550_2061284230599_1911003160_n.jpg"
#    @user.avatar_content_type = "image/jpeg"
#    @user.avatar_file_size = 17185
#    @user.avatar_updated_at = Time.now
    @user.attributes = valid_user_attributes
    @user.should be_valid
  end
end  
