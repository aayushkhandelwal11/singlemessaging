class CreateFlagDetails < ActiveRecord::Migration
  def change
    create_table :flag_details do |t|
      t.integer :user_id
      t.integer :message_id

      t.timestamps
    end
  end
end
