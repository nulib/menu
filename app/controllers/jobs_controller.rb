class JobsController < ApplicationController
  def index
    @jobs = Job.all
  end

  def show
    @images = Job.find( params[ :id ]).images
  end
end
