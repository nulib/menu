class AddIndexToDelayedJobsQueue < ActiveRecord::Migration
  def change
    add_index :delayed_jobs, [:queue], :name => 'delayed_jobs_queue'
  end
end
