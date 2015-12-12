class JobsController < ApplicationController

  layout "jobs", only: [:browse]

  def index
    @jobs = Job.order(:job_id)
  end

  def browse
    @filesystem_location = MENU_CONFIG["images_filesystem_location"]
    @root = root_url
  end

  def import
    file_objects = params[:file_list]
    file_list = []

    file_objects.each do | item |
     file_list << item[1]["url"]
    end
    Delayed::Job.enqueue ImportImagesJob.new(file_list, current_user, root_url)

    head :ok
  end

  def show
    @new_records = Job.find( params[ :id ]).new_records
  end

end
