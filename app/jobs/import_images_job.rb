ImportImagesJob = Struct.new(:file_list, :current_user, :root_url) do

  def enqueue(job)
  end

  def perform
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
    Delayed::Worker.logger.info("I AM SUCCESS #{file_list} and #{root_url}")
    user_email = current_user.get_ldap_email
    Delayed::Worker.logger.info("I AM SUCCESS #{user_email }")
    imported_files = file_list.collect do |file_string|
      file_string.split("dropbox/")[1]
    end.join(", ")

    ImportMailer.successful_import_email(imported_files, user_email, root_url).deliver_now
  end


  def failure(job)
    Delayed::Worker.logger.error("failure really not cool")
    ImportMailer.failed_import_email(imported_files, user_email).deliver_now
  end

  def error(job, exception)
    Delayed::Worker.logger.error("errorrrrrrrr oh great just great and i mean not great")
    Delayed::Worker.logger.error(" job failed because #{exception}")
    #get Airbrake.notify(exception)
  end

  def alert_us_emergency(job, exception)
    #OHMIGOD
  end

end
