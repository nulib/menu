class ImportImagesJob < ActiveJob::Base
  queue_as :image_importing

    rescue_from(StandardError) do |exception|
    # Do something with the exception
      logger.error "oh my god something went wrong #{exception}"
    end

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
            i = job.new_records.create( filename: File.basename(file), proxy: f, location: location)
            raise StandardError.new("Failed to create record for job: #{job_id}") if i.nil?
            f.close
          end

          return i.id
        end
      end
  end

  def success(job)
    logger.info("job  #{job_id} was successful rejoice")
  end

  def failure(job)
    email_us_emergency(job)
  end

  def error(job, exception)
    puts "job #{job_id} failed because #{exception}"
    logger.error(" job #{job_id} failed because #{exception}")
    #get Airbrake.notify(exception)
  end

  def alert_us_emergency(job, exception)
    #OHMIGOD
  end

end
