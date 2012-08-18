class AddUserIdToThreadmessage < ActiveRecord::Migration
  def change
    add_column :threadmessages, :user_id, :integer
  end
end
