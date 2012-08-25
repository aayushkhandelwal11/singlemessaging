ActionMailer::Base.smtp_settings = {  
       :enable_starttls_auto => true,
       :address => 'smtp.gmail.com',
       :port => 587,
       :authentication => :plain,
       :domain =>"aayushmessaging.vinsol.com",
       :user_name => 'aayush8104726it',
       :password => '20315400'
  }
