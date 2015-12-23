namespace :menu do

  desc "task to update current list of images in the db. Should be kicked off by a cron job"
  task :update_image_list => :environment do
    GetImages.current_images
  end

  desc "make deploy owner of all files in dropbox"
  task :chown_the_dropbox_tiffs => :environment do
    command = "chown -R deploy #{MENU_CONFIG["images_dir"]}"
    Delayed::Worker.logger.info("rake task --  #{command}")
    exec command
  end

  desc "make new jobs and records of all files in dropbox"
  task :make_records_for_all_tiffs => :environment do
    GetNewRecords.current_new_records
  end

end
