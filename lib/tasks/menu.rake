namespace :menu do

  desc "task to update current list of images in the db. Should be kicked off by a cron job"
  task :update_image_list => :environment do
    GetImages.current_images( MENU_CONFIG["images_dir"] )
  end

end
