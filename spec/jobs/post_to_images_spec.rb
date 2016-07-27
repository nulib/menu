require 'rails_helper'
Menu::Application.load_tasks

RSpec.describe PostToImagesJob, type: :job do

  let(:user){instance_double("User", :username => "dilpickle", :email => "test@testing.com")}
    before :each do
      @new_record = NewRecord.new(:job_id => 1, :filename => "#{@path}")
      @new_record.save!
      Rake::Task["jobs:clear"].invoke
      ActionMailer::Base.deliveries.clear
      @xml = File.read("#{Rails.root}/spec/fixtures/vra_display_with_content.xml")

      @path = "#{Rails.root}/spec/fixtures/internet.tiff"
      @accession_nbr = "12367"
      body = {"accession_nbr" => @accession_nbr, "from_menu"=>"true", "path" => @path,"xml" => @xml}
      stub_request(:post, "http://127.0.0.1:3333/multiresimages").
      with(:body => body,
       :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'5913', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'})
       .to_return(:status => 200, :body => "<response><returnCode>Publish successful</returnCode><pid>inu:dil-321hdsjfhjs778</pid></response>", :headers => {})
    end

    it "will enqueue a job" do
      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)

      expect(Delayed::Job.count).to eq(1)
    end


    it "will perform an enqueued job" do
      expect(Delayed::Job.count).to eq(0)
      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)
      Delayed::Worker.new.work_off

      expect(Delayed::Job.count).to eq(0)
    end


    it "deletes the new_record while performing the job" do
      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)

      Delayed::Worker.new.work_off

      expect change(NewRecord, :count).by(0)
    end


    it "sends a success email when jobs are succcessful" do
      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)
      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)

      Delayed::Worker.new.work_off

      expect(ActionMailer::Base.deliveries.first.subject).to eq("Your Images record was successfully published")
      expect(ActionMailer::Base.deliveries.last.subject).to eq("Your Images record was successfully published")
    end

    it "sends a failure email when jobs fail" do
      @accession_nbr = ""
      body = {"accession_nbr" => @accession_nbr, "from_menu"=>"true", "path" => @path,"xml" => @xml}
      stub_request(:post, "http://127.0.0.1:3333/multiresimages").
      with(:body => body,
       :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'5908', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'})
       .to_return(:status => 200, :body => "<response><returnCode>Error</returnCode></response>", :headers => {})

      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)

      Delayed::Worker.new.work_off

      expect(ActionMailer::Base.deliveries.last.subject).to eq("Your Images record did not get published")
    end

end
