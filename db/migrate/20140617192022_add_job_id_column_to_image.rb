class AddJobIdColumnToImage < ActiveRecord::Migration
  def change
    add_column :images, :job_id, :string
  end
end
