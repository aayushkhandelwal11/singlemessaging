class AddAttachmentDocumentToAssets < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.has_attached_file :document
    end
  end

  def self.down
    drop_attached_file :assets, :document
  end
end
