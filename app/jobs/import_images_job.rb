class ImportImagesJob < ActiveJob::Base
  queue_as :image_importing

    rescue_from(StandardError) do |exception|
      Delayed::Worker.logger.debug("There was an error: #{exception}")
    end

  def perform(file_list)
    Delayed::Worker.logger.debug("I am file list: #{file_list}")
    begin
    file_list.each do |file_string|

      path = file_string.split( '/' )
      job_id = path[ -2 ]
      file =  file_string
      Delayed::Worker.logger.debug("Am I a file: #{File.file?(file)}")
      proper_file = file.split("file://")[1]


      Delayed::Worker.logger.debug("Am I a proper file: #{File.file?(proper_file)}")


      if File.file?(file)
        job = Job.find_or_create_by( job_id: job_id )
        i = NewRecord.find_by( filename: File.basename( file ), job_id: job, location: File.dirname( file ))
        if i == nil
          file = GetNewRecords.prefix_file_name_with_job_id( file, job_id )
          f = File.open( file )
          i = job.new_records.create( filename: File.basename(file), proxy: f, location: File.dirname( file ))
          raise StandardError.new("Failed to create record for job: #{job_id}") if i.nil?
          f.close
        end

        return i.id
      else
        raise StandardError.new("File doesn't exist for job: #{job_id} and file #{file}")
      end
    end
    rescue => exception
      raise StandardError.new("There was a problem: #{exception}")
    end
  end

  def success(job)
   Delayed::Worker.logger.info("job  #{job_id} was successful rejoice")
  end

  def failure(job)
    email_us_emergency(job)
  end

  def error(job, exception)
    Delayed::Worker.logger.error(" job #{job_id} failed because #{exception}")
    #get Airbrake.notify(exception)
  end

  def alert_us_emergency(job, exception)
    #OHMIGOD
  end

end
