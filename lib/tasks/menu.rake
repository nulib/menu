namespace :menu do

  desc "task to update current list of images in the db. Should be kicked off by a cron job"
  task :update_image_list => :environment do
    GetImages.current_images
  end

  desc "make deploy owner of all files in dropbox"
  task :chown_the_dropbox_tiffs => :environment do
  #command = "cd #{MENU_CONFIG["images_dir"]}; shopt -s extglob; sudo chown -R deploy !(.snapshot)"
  #command = "cd #{MENU_CONFIG["images_dir"]} && echo $? >> cmdlog; shopt -s extglob && echo $? >> cmdlog; s
  #udo chown -R deploy !(.snapshot) && echo $? >> cmdlog"
  #command = "cd #{MENU_CONFIG["images_dir"]} && find . -not -path '*/\.*' -type f -name '*.tif*' | xargs sudo chown deploy; find \! -name '.*' -type d | xargs sudo chown deploy"
  end


  desc "make new jobs and records of all files in dropbox"
  task :make_records_for_all_tiffs => :environment do
    GetNewRecords.current_new_records
  end

end
