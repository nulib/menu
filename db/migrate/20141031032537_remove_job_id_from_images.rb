class RemoveJobIdFromImages < ActiveRecord::Migration
  def up
    remove_column :images, :job_id
  end

  def down
    add_column :images, :job_id, :string
  end
end
