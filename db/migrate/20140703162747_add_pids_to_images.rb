class AddPidsToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_pid, :string
    add_column :images, :work_pid, :string
  end
end
