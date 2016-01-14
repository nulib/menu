require 'open3'

ImportImagesJob = Struct.new(:file_list, :user_email, :root_url) do

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

    #crucial: need to keep the tiffs owned by deploy in production, needed visudo to allow deploy to sudo and !requiretty for it
    if Rails.env == "production" or Rails.env == "staging"
      stdout, stdeerr, status = Open3.capture3("sudo chown -R deploy:librepofiles-images-rw #{MENU_CONFIG["images_dir"]}/*")
      Delayed::Worker.logger.info(status)
      Delayed::Worker.logger.info(stdeerr)
      Delayed::Worker.logger.info(stdout)
   end
    rescue => exception
      raise StandardError.new("There was a problem: #{exception}")
    end
  end


  def success(job)
    Delayed::Worker.logger.info("SUCCESS #{file_list} and #{root_url}")
    imported_files = file_list.collect do |file_string|
      file_string.split("dropbox/")[1]
    end.join(", ")

    ImportMailer.successful_import_email(imported_files, user_email, root_url).deliver_now
  end


  def failure(job)
    Delayed::Worker.logger.error("#{job} failure")

    imported_files = file_list.collect do |file_string|
      file_string.split("dropbox/")[1]
    end.join(", ")

    ImportMailer.failed_import_email(imported_files, user_email).deliver_now
  end

  def error(job, exception)
    Delayed::Worker.logger.error(" job caused error because #{exception}")

    imported_files = file_list.collect do |file_string|
      file_string.split("dropbox/")[1]
    end.join(", ")

    ImportMailer.failed_import_email(imported_files, "jennifer.lindner@northwestern.edu").deliver_now
  end

  def alert_us_emergency(job, exception)
    #text notification, airbrake, etc
  end

end
