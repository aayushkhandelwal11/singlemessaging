class AddSendToThreadmessage < ActiveRecord::Migration
   def change
    add_column :threadmessages, :draft, :integer
  end
end
