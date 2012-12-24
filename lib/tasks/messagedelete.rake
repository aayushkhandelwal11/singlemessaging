desc "Deleting Message"
task :delete_message => :environment do 
  messages = Message.where('id != parent_id')
  messages.each do |message|
    if ! message.receivers.exists?(:status =>[0,1,2,3])
    	message.destroy
    end
  end 

  parentmessages = Message.where('id = parent_id')
  parentmessages.each do |message|
    if Message.find_all_by_parent_id(message.id).count == 1
      if !message.receivers.exists?(:status => [0, 1, 2, 3] )
       	message.destroy
      end
    end
  end
end	


