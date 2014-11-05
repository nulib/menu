class AddJobIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :job_id, :integer
  end
end
