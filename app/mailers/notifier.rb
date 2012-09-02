class Notifier < ActionMailer::Base
  default from: "admin<aayush81047626it@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.gmail_message.subject
  #
  def gmail_message(user1,user)
    @greeting = "Hi"
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
