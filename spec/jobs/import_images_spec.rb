require 'rails_helper'
Menu::Application.load_tasks

RSpec.describe ImportImagesJob, type: :job do
  let(:file_objects) {{
      "0"=>{"url"=>"file://#{Rails.root}/#{MENU_CONFIG['images_dir']}/123/123_internet.tiff", "file_name"=>"123_internet.tiff", "file_size"=>"792132"},
      "1"=>{"url"=>"file://#{Rails.root}/#{MENU_CONFIG['images_dir']}/123/123_Rodinia.tiff", "file_name"=>"123_Rodinia.tiff", "file_size"=>"429296"},
      "2"=>{"url"=>"file://#{Rails.root}/#{MENU_CONFIG['images_dir']}/123/123_technology.tiff", "file_name"=>"123_technology.tiff", "file_size"=>"904934"}}}

  let(:user){instance_double("User", :username => "dilpickle", :email => "test@testing.com")}

    before :each do
      Rake::Task["jobs:clear"].invoke
    end

    it "will enqueue a job" do
      file_list = []
      file_objects.each do | item |
       file_list << item[1]["url"]
      end

      expect(Delayed::Job.count).to eq(0)
      Delayed::Job.enqueue ImportImagesJob.new(file_list, :user, "localhost")

      expect(Delayed::Job.count).to eq(1)
    end


    it "will perform an enqueued job" do
      file_list = []
      file_objects.each do | item |
       file_list << item[1]["url"]
      end

      Delayed::Job.enqueue ImportImagesJob.new(file_list, user.email, "localhost")

      Delayed::Worker.new.work_off

      expect(Delayed::Job.count).to eq(0)
    end

    it "will enqueue the job with the correct files in the correct queue" do
      file_list = []
      file_objects.each do | item |
       file_list << item[1]["url"]
      end

      Delayed::Job.enqueue ImportImagesJob.new(file_list, user.email, "localhost")

      expect(Delayed::Job.last.payload_object.file_list).to eq(file_list)
      expect(Delayed::Job.last.queue).to eq(Delayed::Worker.default_queue_name)
    end


    it "sends a status emails when jobs get run" do
      file_list = []
      file_objects.each do | item |
       file_list << item[1]["url"]
      end

      Delayed::Job.enqueue ImportImagesJob.new(file_list, user.email, "localhost")

      bad_files = {
        "0"=>{"url"=> "/123/123_internet.tiff", "file_name"=>"123_internet.tiff", "file_size"=>"792132"},
        "1"=>{"url"=> "/123/123_Rodinia.tiff", "file_name"=>"123_Rodinia.tiff", "file_size"=>"429296"},
        "2"=>{"url"=> "/123/123_technology.tiff", "file_name"=>"123_technology.tiff", "file_size"=>"904934"}}

      file_list = []
      file_objects.each do | item |
       file_list << item[1]["url"]
      end

      Delayed::Job.enqueue ImportImagesJob.new(bad_files, user.email, "localhost")

      Delayed::Worker.new.work_off

      expect(ActionMailer::Base.deliveries.first.subject).to eq("Your Menu job has been successfully imported")
      expect(ActionMailer::Base.deliveries.last.subject).to eq("Your Menu job did not get imported")
    end
end

