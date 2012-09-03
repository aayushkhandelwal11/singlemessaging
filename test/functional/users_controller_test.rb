require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  test "should not update without name " do
    assert_same('User.count') do
      post :create, user: { age: @user.age, email: @user.email }
    end
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { age: @user.age, email: @user.email, name: @user.name , @notification: "1" , password_digest:}
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { age: @user.age, email: @user.email, name: @user.name }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
