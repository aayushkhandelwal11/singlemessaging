#require 'test_helper'

#class ThreadmessagesControllerTest < ActionController::TestCase
#  setup do
#    @threadmessage = threadmessages(:one)
#  end

#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:threadmessages)
#  end

#  test "should get new" do
#    get :new
#    assert_response :success
#  end

#  test "should create threadmessage" do
#    assert_difference('Threadmessage.count') do
#      post :create, threadmessage: { description: @threadmessage.description, status: @threadmessage.status }
#    end

#    assert_redirected_to threadmessage_path(assigns(:threadmessage))
#  end

#  test "should show threadmessage" do
#    get :show, id: @threadmessage
#    assert_response :success
#  end

#  test "should get edit" do
#    get :edit, id: @threadmessage
#    assert_response :success
#  end

#  test "should update threadmessage" do
#    put :update, id: @threadmessage, threadmessage: { description: @threadmessage.description, status: @threadmessage.status }
#    assert_redirected_to threadmessage_path(assigns(:threadmessage))
#  end

#  test "should destroy threadmessage" do
#    assert_difference('Threadmessage.count', -1) do
#      delete :destroy, id: @threadmessage
#    end

#    assert_redirected_to threadmessages_path
#  end
#end
