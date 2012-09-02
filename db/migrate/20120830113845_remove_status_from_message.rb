class RemoveStatusFromMessage < ActiveRecord::Migration
 def change
    remove_column :messages, :status, :string
 end
end
