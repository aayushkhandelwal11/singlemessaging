class RemoveThreadmessageIdFromAsset < ActiveRecord::Migration
  def change
    remove_column :assets, :threadmessage_id , :integer
    add_column :assets, :message_id , :integer
  end
end
