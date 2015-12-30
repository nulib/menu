namespace :delayed_job do

  desc "find any running dj jobs and kill them by pid"
  task :kill_the_djs => :environment do
    #delete all files that start with delayed_job in tmp/pids

    Dir.glob("#{Rails.root}/tmp/pids/*") do |f|
      if f.include?("delayed_job") and f.include?(".pid")
        pid = File.open(f, "r")
        pid.each_line do |line|
          puts line
          `kill -9 #{line}`
        end
        pid.close()
      end
    end
  end
end
