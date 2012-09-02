class AddContentToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :content, :string
    add_column :messages, :parent_id, :integer
  end
end
