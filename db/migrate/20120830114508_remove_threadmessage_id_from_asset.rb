class RemoveThreadmessageIdFromAsset < ActiveRecord::Migration
  def change
    add_column :assets, :message_id , :integer
  end
end
