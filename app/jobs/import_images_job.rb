class ImportImagesJob < ActiveJob::Base
  queue_as :image_importing

    rescue_from(StandardError) do |exception|
      Delayed::Worker.logger.debug("There was an error: #{exception}")
    end

  def perform(file_list)
    begin
    file_list.each do |file_string|
      path = file_string.split( '/' )
      job_id = path[ -2 ]
      proper_file = file_string.split("file://")[1]

      if File.file?(proper_file)
        job = Job.find_or_create_by( job_id: job_id )
        i = NewRecord.find_by( filename: File.basename( proper_file ), job_id: job, location: File.dirname( proper_file ))
        if i == nil
          proper_file = GetNewRecords.prefix_file_name_with_job_id( proper_file, job_id )
          f = File.open( proper_file )
          i = job.new_records.create( filename: File.basename(proper_file), proxy: f, location: File.dirname( proper_file ))
          raise StandardError.new("Failed to create record for job: #{job_id}") if i.nil?
          f.close
        end
        i.id
      else
        raise StandardError.new("File doesn't exist for job: #{job_id} and file #{proper_file}")
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
