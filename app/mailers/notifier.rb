class Notifier < ActionMailer::Base
  #default from: "Messaging App<aayush81047626it@gmail.com>"

  def gmail_message(user1,user,url)
    @greeting = "Hi"
    @path= url
    @user=user
    @user1=user1
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Recieved a message")
  end
  def welcome_message(user)
    @greeting = "Hi"
    @user=user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "welcome")
  end
  
  def send_password(user,pass)
    @pass=pass
    @greeting = "Hi"
    @user=user
    mail(:to => "#{user.name} <#{user.email}>", :subject => " Password")
  end
end
