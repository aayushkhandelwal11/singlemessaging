require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @message = messages(:one)
    session[:user_id]=42
    session[:list_users]=[31]
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create single message" do
    assert_difference('Message.count') do
      post :create, message: { status: @message.status }
    end

    assert_redirected_to message_path(assigns(:message))
  end

  test "should show message" do
    get :show, id: @message
    assert_response :success
  end

#   test "should destroy message" do
#    assert_difference('Message.count', -1) do
#      delete :destroy, id: @message
#    end

#    assert_redirected_to messages_path
#  end
end
