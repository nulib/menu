class JobsController < ApplicationController
  def index
    GetImages.current_images
    @jobs = Job.all
  end

  def show
    @images = Job.find( params[ :id ]).images
  end
end
