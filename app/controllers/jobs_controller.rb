class JobsController < ApplicationController
  def index
    GetImages.current_images
    @jobs = Job.order(:job_id)
  end

  def show
    @images = Job.find( params[ :id ]).images
  end
end
