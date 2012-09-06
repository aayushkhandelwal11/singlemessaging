require 'spec_helper'

describe UsersController, "creating a new user" do
  #integrate_views
  it "should redirect to login_url with a notice" do
    User.any_instance.stubs(:valid?).returns(true)
    post 'create'
    response.should redirect_to(login_url)
  end
  it "Should not save the user and rerender new" do 
  end
end
