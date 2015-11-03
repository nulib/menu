require 'rails_helper'
include ActiveJob::TestHelper


RSpec.describe ImportImagesJob, type: :job do
    it "will enqueue a job" do

      file_objects ={"0"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_internet.tiff", "file_name"=>"123_internet.tiff", "file_size"=>"792132"}, "1"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_Rodinia.tiff", "file_name"=>"123_Rodinia.tiff", "file_size"=>"429296"}, "2"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_technology.tiff", "file_name"=>"123_technology.tiff", "file_size"=>"904934"}}
      file_list = []

      file_objects.each do | item |
       file_list << item[1]["url"]
      end

      assert_enqueued_with(job: ImportImagesJob) do
          ImportImagesJob.perform_later file_list
      end
    end

    it "will perform an enqueued job" do
      assert_performed_jobs(0)

      file_objects ={
        "0"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_internet.tiff", "file_name"=>"123_internet.tiff", "file_size"=>"792132"},
        "1"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_Rodinia.tiff", "file_name"=>"123_Rodinia.tiff", "file_size"=>"429296"},
        "2"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_technology.tiff", "file_name"=>"123_technology.tiff", "file_size"=>"904934"}}
      file_list = []

      file_objects.each do | item |
       file_list << item[1]["url"]
      end

      perform_enqueued_jobs do
        ImportImagesJob.perform_later(file_list)
        puts "#{enqueued_jobs}"
      end

     assert_performed_jobs(1)
  end

  it "will enqueue the correct job with the correct files in the correct queue" do

      file_objects ={
        "0"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_internet.tiff", "file_name"=>"123_internet.tiff", "file_size"=>"792132"},
        "1"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_Rodinia.tiff", "file_name"=>"123_Rodinia.tiff", "file_size"=>"429296"},
        "2"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_technology.tiff", "file_name"=>"123_technology.tiff", "file_size"=>"904934"}}

      file_list = []

      file_objects.each do | item |
       file_list << item[1]["url"]
      end

     # ImportImagesJob.perform_later(file_list)

      assert_enqueued_with(job: ImportImagesJob, args: [file_list], queue: "#{Rails.env}_image_importing") do
        ImportImagesJob.perform_later(file_list)
          puts "it should be one: #{enqueued_jobs.size}"
        #Delayed::Job.all.each{|d| d.run_at = Time.now; d.save!}
        #Delayed::Worker.new.run(Delayed::Job.last)
      end
    end

end
