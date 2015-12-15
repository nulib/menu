require 'rails_helper'


RSpec.describe ImportImagesJob, type: :job do

  #need to stub out actionmailer and make sure success and fail email methods get called

  before :all do
    file_objects ={
      "0"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_internet.tiff", "file_name"=>"123_internet.tiff", "file_size"=>"792132"},
      "1"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_Rodinia.tiff", "file_name"=>"123_Rodinia.tiff", "file_size"=>"429296"},
      "2"=>{"url"=>"file:///Users/jld555/projects/menu/lib/assets/dropbox/123/123_technology.tiff", "file_name"=>"123_technology.tiff", "file_size"=>"904934"}}
    file_list = []

    file_objects.each do | item |
     file_list << item[1]["url"]
    end
  end

    it "will enqueue a job" do

    end

    it "will perform an enqueued job" do
      expect(Delayed::Job.count).to eq(0)

      ImportImagesJob.perform_later(file_list)

      expect(Delayed::Job.count).to eq(1)
  end

  it "will enqueue the correct job with the correct files in the correct queue" do

      expect this stuff  --- job: ImportImagesJob, args: [file_list], queue: "image_importing"
        ImportImagesJob.perform_later(file_list)
        #Delayed::Job.all.each{|d| d.run_at = Time.now; d.save!}
        #Delayed::Worker.new.run(Delayed::Job.last)
      end
    end

end
