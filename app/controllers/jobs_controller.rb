class JobsController < ApplicationController
  def index
    GetNewRecords.current_new_records
    @jobs = Job.order(:job_id)
  end

  def show
    @new_records = Job.find( params[ :id ]).new_records
  end
end
