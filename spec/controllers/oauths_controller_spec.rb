require 'spec_helper'

describe OauthsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'genereate'" do
    it "returns http success" do
      get 'genereate'
      response.should be_success
    end
  end

end
