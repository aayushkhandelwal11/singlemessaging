class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :status
      

      t.timestamps
    end
  end
end
