class ImportImagesJob < ActiveJob::Base
  queue_as :image_importing

    # rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # # Do something with the exception
    #   puts "oh my god, something went wrong #{exception}"
    # end

  def perform(file_list)
      file_list.each do |file_string|
        path = file_string.split( '/' )
        job_id = path[ -2 ]
        file = file_string.split("#{Rails.root}/")[1]
        if File.file?( file )
          job = Job.find_or_create_by( job_id: job_id )

          location = File.dirname( file ).sub(/#{Rails.root}\//, '')
          i = NewRecord.find_by( filename: File.basename( file ), job_id: job, location: location)
          if i == nil
            file = GetNewRecords.prefix_file_name_with_job_id( file, job_id )
            f = File.open( file )
            i = job.new_records.create( filename: File.basename( file ), proxy: f, location: location )
            f.close
          end

          return i.id
        end
      end

  end
end
