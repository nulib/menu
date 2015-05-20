class RenameImagesTable < ActiveRecord::Migration
  def change
    rename_table :images, :new_records
  end
end
