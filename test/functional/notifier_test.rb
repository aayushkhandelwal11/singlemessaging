require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "gmail_message" do
    user=User.find_by_name "rahul"
    user1=User.find_by_name "rahul"
    mail = Notifier.gmail_message(user,user1)
    assert_equal "Recieved a message", mail.subject
    assert_equal ["kuldeep.aggarwal@vinsol.com"], mail.to
    assert_equal ["aayush8104726it@gmail.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end
#  test "gmail_message" do
#    mail = Notifier.gmail_message
#    assert_equal "Gmail message", mail.subject
#    assert_equal ["to@example.org"], mail.to
#    assert_equal ["from@example.com"], mail.from
#    assert_match "Hi", mail.body.encoded
#  end

end
