class ChangeStatusTypeInReceiver < ActiveRecord::Migration
  def change
    change_column :receivers, :status, :integer
  end
end
