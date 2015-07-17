namespace :menu do

  desc "task to update current list of images in the db. Should be kicked off by a cron job"
  task :update_image_list => :environment do
    GetImages.current_images
  end

  desc "recreate image tags on index page after deploys"
  task :recreate_image_tags => :environment do
    # this may not be the way to do it. It may require a get all in one way or another though.
    # this might also be a good way to test getting groups to work: empty gemfile, bundle install to
    # make sure .lock is emty too, on the env ironment run bundle clean --force to empty,
    # then try install again to see if only the gems specified in the groups ACTUALLY get installed.
    new_records = NewRecord.all
    new_records.each do | nr |
      nr.proxy
    end

  end

end
