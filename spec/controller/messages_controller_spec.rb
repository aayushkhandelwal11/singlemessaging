#require 'spec_helper'

#describe MessagesController, "#route_for" do

#  it "should map { :controller => 'messages', :action => 'index' } to /messages" do
#    { :get => "/messages" }.should route_to(:controller => "messages", :action => "index")
#    # route_for(:controller => "messages", :action => "index").should == "/messages"
#  end
#  
#  it "should map { :controller => 'messages', :action => 'new' } to /messages/new" do
#    { :get => "/messages/new" }.should route_to(:controller => "messages", :action => "new")
#    # route_for(:controller => "messages", :action => "new").should == "/messages/new"
#  end
#  
#  it "should map { :controller => 'messages', :action => 'show' } to /messages/1" do
#    { :get => "/messages/1" }.should route_to(:controller => "messages", :action => "show", :id => "1")
#    # route_for(:controller => "messages", :action => "show", :id => 1).should == "/messages/1"
#  end
#  
#  it "should map { :controller => 'messages', :action => 'edit', :id => 1 } to /messages/1/edit" do
#    { :get => "/messages/1/edit" }.should route_to(:controller => "messages", :action => "edit", :id => "1")
#    # route_for(:controller => "messages", :action => "edit", :id => 1).should == "/messages/1/edit"
#  end
#  
#  it "should map { :controller => 'messages', :action => 'outbox'} to /messages/outbox" do
#    { :put => "/messages/outbox" }.should route_to(:controller => "messages", :action => "outbox")
#    # route_for(:controller => "messages", :action => "update", :id => 1).should == "/messages/1"
#  end
#  it "should map { :controller => 'messages', :action => 'drafts'} to /messages/drafts" do
#    { :put => "/messages/drafts" }.should route_to(:controller => "messages", :action => "drafts")
#    # route_for(:controller => "messages", :action => "update", :id => 1).should == "/messages/1"
#  end  
#  it "should map { :controller => 'messages', :action => 'destroy', :id => 1} to /messages/1" do
#    { :delete => "/messages/1" }.should route_to(:controller => "messages", :action => "destroy", :id => "1")
#    # route_for(:controller => "messages", :action => "destroy", :id => 1).should == "/messages/1"
#  end
#end

