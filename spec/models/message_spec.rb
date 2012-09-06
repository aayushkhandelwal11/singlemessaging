require 'spec_helper'
module MessageSpecHelper
  def valid_message_attributes
    { :sender_id => 42, :content=>"content",
      :subject => "subject",
      :flagged => true   
    }
  end
end
describe Message do
  include MessageSpecHelper
  before(:each) do
    @message=Message.new
  end
  it "sender id is nil " do
    @message.attributes = valid_message_attributes.except(:sender_id)
    @message.should have(1).error_on(:sender_id)
  end
  it "valid entry " do
    @message.attributes = valid_message_attributes
    @message.should be_valid
  end
  
end  
