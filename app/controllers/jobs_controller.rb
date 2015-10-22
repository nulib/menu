class JobsController < ApplicationController

  layout "jobs", only: [:browse]

  def index
    @jobs = Job.order(:job_id)
  end

  def browse
  end

  def import
    #location = MENU_CONFIG["images_dir"]
    location = params[:file_list]
    puts "yo params      #{params[:file_list]}"
    #okay so one thing could be to have the browse pass in the "location"
    #it doesn't need to be a directory, it can be an array of files.
    #you'd need to replace dir.glob with another method for walking the set of files
    #in the array.
    # records = []
    # dir_contents = Dir.glob( "#{location}/**/*" )
    # dir_contents.delete_if { |dir| dir =~ /_completed/ }
    # dir_contents.each do |file|
    #   records << GetNewRecords.find_or_create_new_record(file)
    # end

    # GetNewRecords.remove_stale_new_records(records)

  end

  def show
    @new_records = Job.find( params[ :id ]).new_records
  end

end
