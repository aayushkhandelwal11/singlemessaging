class CreateThreadmessages < ActiveRecord::Migration
  def change
    create_table :threadmessages do |t|
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
