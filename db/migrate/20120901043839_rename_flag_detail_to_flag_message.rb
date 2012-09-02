class RenameFlagDetailToFlagMessage < ActiveRecord::Migration
  def change
    rename_table :flag_details, :flag_messages
  end 
end
