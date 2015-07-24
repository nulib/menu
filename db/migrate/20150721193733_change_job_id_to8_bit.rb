class ChangeJobIdTo8Bit < ActiveRecord::Migration
  def up
    remove_column :jobs, :job_id, :integer
    add_column :jobs, :job_id, :integer, :limit => 8
  end
  def down
  end
end
