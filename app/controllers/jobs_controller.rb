class JobsController < ApplicationController

  layout "jobs", only: [:browse]

  def index
    @jobs = Job.order(:job_id)
  end

  def browse
  end

  def import
    #location = MENU_CONFIG["images_dir"]
    file_objects = params[:file_list]

    #okay so one thing could be to have the browse pass in the "location"
    #it doesn't need to be a directory, it can be an array of files.
    #you'd need to replace dir.glob with another method for walking the set of files
    #in the array.
    file_list = []
    records = []
    # dir_contents = Dir.glob( "#{location}/**/*" )
    file_objects.each do | item |
     file_list << item[1]["url"]
    end

    file_list.each do |file|
      #delay??
      records << GetNewRecords.find_or_create_new_record(file)
    end

     GetNewRecords.remove_stale_new_records(records)

  end

  def show
    @new_records = Job.find( params[ :id ]).new_records
  end

end
