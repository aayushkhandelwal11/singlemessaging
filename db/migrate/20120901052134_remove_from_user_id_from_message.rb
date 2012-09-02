class RemoveFromUserIdFromMessage < ActiveRecord::Migration
  def change
    remove_column :messages, :from_user_id, :integer
    add_column :messages, :sender_id, :integer
  end
end
