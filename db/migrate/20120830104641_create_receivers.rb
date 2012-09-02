class CreateReceivers < ActiveRecord::Migration
  def change
    create_table :receivers do |t|
      t.integer :message_id
      t.integer :user_id
      t.string  :status
      t.boolean :read
      t.timestamps
    end
  end
end
