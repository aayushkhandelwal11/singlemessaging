require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
     @user=User.new
     @user.name="rahul"
     @user.password= "rahulvinsol"
     @user.password_confirmation="rahulvinsol"
     @user.email="rahul@vinsol.com"
     @user.age=22
     @user.notification="1"
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  test "should not create user without age" do
     @user.age=nil
     assert !@user.save, "Saved the User without age"
  end
  
  test "should not create without name" do
    @user.name=nil
    
    assert !@user.save, "Saved the User without a name"
  end
  
  test "should create user" do
     assert @user.save, "Not saved"
  end
  test "should not create user with same email" do
    newuser=User.new
    newuser.name="rahul11"
    newuser.age=34
    newuser.email="rahul@vinsol.com"
    newuser.password="password"
    newuser.password_confirmation="password"
    
    assert newuser.save, "Saved the User with same email"
  end


  test "should not create user with same name" do
    newuser=User.new
    newuser.name="rahul"
    newuser.age=34
    newuser.email="rahul11@sd.com"
    newuser.password="password"
    newuser.password_confirmation="password"
    
    assert newuser.save, "Saved the User with same name"
  end
  



  test "should get edit" do
    assert @user.save, "Not saved"
    session[:user_id]=@user.id
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    assert @user.save, "Not saved"
    session[:user_id]=@user.id
    put :update, id: @user, user: { notification:"0" }
    assert_redirected_to edit_user_path(assigns(:user))
  end

end
