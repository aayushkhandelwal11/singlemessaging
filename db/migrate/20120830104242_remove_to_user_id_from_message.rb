class RemoveToUserIdFromMessage < ActiveRecord::Migration
  def change
    remove_column :messages, :to_user_id, :integer
  end
end
