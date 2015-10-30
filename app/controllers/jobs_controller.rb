class JobsController < ApplicationController

  layout "jobs", only: [:browse]

  def index
    @jobs = Job.order(:job_id)
  end

  def browse
  end

  def import
    file_objects = params[:file_list]
    file_list = []

    file_objects.each do | item |
     file_list << item[1]["url"]
    end

    ImportImagesJob.perform_later(file_list)

    # file_list.each do |file|
    #   records << NewRecord.find_or_create_new_record(file)
    # end
    #  GetNewRecords.remove_stale_new_records(records)

  end

  def show
    @new_records = Job.find( params[ :id ]).new_records
  end

end
