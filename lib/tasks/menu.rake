namespace :menu do

  desc "task to update current list of images in the db. Should be kicked off by a cron job"
  task :update_image_list => :environment do
    GetImages.current_images
  end

  desc "make deploy owner of all files in dropbox"
  task :chown_the_dropbox_tiffs => :environment do
    command = "cd #{Rails.root}/#{MENU_CONFIG["images_dir"]} && find . -type f -name '*.tiff' | xargs chown deploy"
    puts "#{command}"
    exec command
  end

end
