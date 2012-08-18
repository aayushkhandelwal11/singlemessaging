class AddMessageIdToThreadmessage < ActiveRecord::Migration
  def change
    add_column :threadmessages, :message_id, :integer
  end
end
