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
    end

    it "will enqueue a job" do
      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)

      expect(Delayed::Job.count).to eq(1)
    end


    it "will perform an enqueued job" do
      expect(Delayed::Job.count).to eq(0)
      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)
      stub_request(:post, "http://127.0.0.1:3331/multiresimages").
        with(:body => {"accession_nbr"=>"12367", "from_menu"=>"true", "path"=>"#{Rails.root.join}/spec/fixtures/internet.tiff", "xml"=>"       <?xml version=\"1.0\"?>\n       <vra:vra xmlns:fn=\"http://www.w3.org/2005/xpath-functions\" xmlns:marc=\"http://www.loc.gov/MARC21/slim\" xmlns:mods=\"http://www.loc.gov/mods/v3\" xmlns:vra=\"http://www.vraweb.org/vracore4.htm\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd\">\n         <vra:image id=\"inu-dil-219157_w\" refid=\"inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c\">\n\n           <vra:agentSet><vra:display>Lysippos attributed to</vra:display>\n             <vra:agent>\n               <vra:name type=\"personal\" vocab=\"ulan\">Lysippos attributed to</vra:name>\n               <vra:attribution/>\n             </vra:agent>\n           </vra:agentSet>\n           <vra:culturalContextSet><vra:display/>\n             <vra:culturalContext/>\n           </vra:culturalContextSet>\n\n           <vra:dateSet>\n             <vra:display>ca. 325 BCE - 300 BCE</vra:display>\n             <vra:date type=\"creation\">\n               <vra:earliestDate>-0324</vra:earliestDate>\n               <vra:latestDate>-0299</vra:latestDate>\n             </vra:date>\n           </vra:dateSet>\n           <vra:inscriptionSet><vra:display/>\n             <vra:inscription>\n               <vra:text/>\n             </vra:inscription>\n           </vra:inscriptionSet>\n\n           <vra:locationSet><vra:display>Delphi Museum ; Delphi ; inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c ; Voyager:attributed to</vra:display>\n             <vra:location type=\"repository\">\n               <vra:name type=\"corporate\">Delphi Museum</vra:name>\n               <vra:name type=\"geographic\">Delphi</vra:name>\n             </vra:location>\n             <vra:location>\n               <vra:refid source=\"DIL\">inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c</vra:refid>\n               <vra:refid source=\"Voyager\">attributed to</vra:refid>\n             </vra:location>\n           </vra:locationSet>\n\n           <vra:materialSet><vra:display>\"marble, after bronze original\"</vra:display>\n             <vra:material>\"marble, after bronze original\"</vra:material>\n           </vra:materialSet>\n\n           <vra:relationSet><vra:display>\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:display>\n             <vra:relation pref=\"true\" relids=\"inu:dil-068f652d-3e46-4067-9698-084a9a20813a\" type=\"imageOf\">\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:relation>\n           </vra:relationSet>\n\n           <vra:stylePeriodSet><vra:display>Greek Classical Period</vra:display>\n             <vra:stylePeriod>Greek Classical Period</vra:stylePeriod>\n           </vra:stylePeriodSet>\n           <vra:techniqueSet><vra:display/>\n             <vra:technique/>\n           </vra:techniqueSet>\n\n           <vra:titleSet><vra:display>\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:display>\n             <vra:title pref=\"true\">\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:title>\n           </vra:titleSet>\n\n           <vra:worktypeSet><vra:display>Sculpture</vra:display>\n             <vra:worktype vocab=\"local\">Sculpture</vra:worktype>\n           </vra:worktypeSet>\n         </vra:image>\n       </vra:vra>"},
        :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})
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

      stub_request(:post, "http://127.0.0.1:3331/multiresimages").
        with(:body => {"accession_nbr"=>"12367", "from_menu"=>"true", "path"=>"#{Rails.root.join}/spec/fixtures/internet.tiff", "xml"=>"       <?xml version=\"1.0\"?>\n       <vra:vra xmlns:fn=\"http://www.w3.org/2005/xpath-functions\" xmlns:marc=\"http://www.loc.gov/MARC21/slim\" xmlns:mods=\"http://www.loc.gov/mods/v3\" xmlns:vra=\"http://www.vraweb.org/vracore4.htm\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd\">\n         <vra:image id=\"inu-dil-219157_w\" refid=\"inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c\">\n\n           <vra:agentSet><vra:display>Lysippos attributed to</vra:display>\n             <vra:agent>\n               <vra:name type=\"personal\" vocab=\"ulan\">Lysippos attributed to</vra:name>\n               <vra:attribution/>\n             </vra:agent>\n           </vra:agentSet>\n           <vra:culturalContextSet><vra:display/>\n             <vra:culturalContext/>\n           </vra:culturalContextSet>\n\n           <vra:dateSet>\n             <vra:display>ca. 325 BCE - 300 BCE</vra:display>\n             <vra:date type=\"creation\">\n               <vra:earliestDate>-0324</vra:earliestDate>\n               <vra:latestDate>-0299</vra:latestDate>\n             </vra:date>\n           </vra:dateSet>\n           <vra:inscriptionSet><vra:display/>\n             <vra:inscription>\n               <vra:text/>\n             </vra:inscription>\n           </vra:inscriptionSet>\n\n           <vra:locationSet><vra:display>Delphi Museum ; Delphi ; inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c ; Voyager:attributed to</vra:display>\n             <vra:location type=\"repository\">\n               <vra:name type=\"corporate\">Delphi Museum</vra:name>\n               <vra:name type=\"geographic\">Delphi</vra:name>\n             </vra:location>\n             <vra:location>\n               <vra:refid source=\"DIL\">inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c</vra:refid>\n               <vra:refid source=\"Voyager\">attributed to</vra:refid>\n             </vra:location>\n           </vra:locationSet>\n\n           <vra:materialSet><vra:display>\"marble, after bronze original\"</vra:display>\n             <vra:material>\"marble, after bronze original\"</vra:material>\n           </vra:materialSet>\n\n           <vra:relationSet><vra:display>\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:display>\n             <vra:relation pref=\"true\" relids=\"inu:dil-068f652d-3e46-4067-9698-084a9a20813a\" type=\"imageOf\">\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:relation>\n           </vra:relationSet>\n\n           <vra:stylePeriodSet><vra:display>Greek Classical Period</vra:display>\n             <vra:stylePeriod>Greek Classical Period</vra:stylePeriod>\n           </vra:stylePeriodSet>\n           <vra:techniqueSet><vra:display/>\n             <vra:technique/>\n           </vra:techniqueSet>\n\n           <vra:titleSet><vra:display>\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:display>\n             <vra:title pref=\"true\">\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:title>\n           </vra:titleSet>\n\n           <vra:worktypeSet><vra:display>Sculpture</vra:display>\n             <vra:worktype vocab=\"local\">Sculpture</vra:worktype>\n           </vra:worktypeSet>\n         </vra:image>\n       </vra:vra>"},
        :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "<response><returnCode>Publish successful</returnCode><pid>inu:dil-321hdsjfhjs778</pid></response>", :headers => {})

      Delayed::Worker.new.work_off

      expect(ActionMailer::Base.deliveries.first.subject).to eq("Your Images record was successfully published")
      expect(ActionMailer::Base.deliveries.last.subject).to eq("Your Images record was successfully published")
    end

    it "sends a failure email when jobs fail" do
      @accession_nbr = ""
      body = {"accession_nbr" => @accession_nbr, "from_menu"=>"true", "path" => @path,"xml" => @xml}
      Delayed::Job.enqueue PostToImagesJob.new(@xml, @path, @accession_nbr, @new_record.id, user.email)

      stub_request(:post, "http://127.0.0.1:3331/multiresimages").
        with(:body => {"accession_nbr"=>"", "from_menu"=>"true", "path"=>"#{Rails.root.join}/spec/fixtures/internet.tiff", "xml"=>"       <?xml version=\"1.0\"?>\n       <vra:vra xmlns:fn=\"http://www.w3.org/2005/xpath-functions\" xmlns:marc=\"http://www.loc.gov/MARC21/slim\" xmlns:mods=\"http://www.loc.gov/mods/v3\" xmlns:vra=\"http://www.vraweb.org/vracore4.htm\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd\">\n         <vra:image id=\"inu-dil-219157_w\" refid=\"inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c\">\n\n           <vra:agentSet><vra:display>Lysippos attributed to</vra:display>\n             <vra:agent>\n               <vra:name type=\"personal\" vocab=\"ulan\">Lysippos attributed to</vra:name>\n               <vra:attribution/>\n             </vra:agent>\n           </vra:agentSet>\n           <vra:culturalContextSet><vra:display/>\n             <vra:culturalContext/>\n           </vra:culturalContextSet>\n\n           <vra:dateSet>\n             <vra:display>ca. 325 BCE - 300 BCE</vra:display>\n             <vra:date type=\"creation\">\n               <vra:earliestDate>-0324</vra:earliestDate>\n               <vra:latestDate>-0299</vra:latestDate>\n             </vra:date>\n           </vra:dateSet>\n           <vra:inscriptionSet><vra:display/>\n             <vra:inscription>\n               <vra:text/>\n             </vra:inscription>\n           </vra:inscriptionSet>\n\n           <vra:locationSet><vra:display>Delphi Museum ; Delphi ; inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c ; Voyager:attributed to</vra:display>\n             <vra:location type=\"repository\">\n               <vra:name type=\"corporate\">Delphi Museum</vra:name>\n               <vra:name type=\"geographic\">Delphi</vra:name>\n             </vra:location>\n             <vra:location>\n               <vra:refid source=\"DIL\">inu:dil-86a0e7d3-fdd5-4b12-87a6-6e1fb74e1c4c</vra:refid>\n               <vra:refid source=\"Voyager\">attributed to</vra:refid>\n             </vra:location>\n           </vra:locationSet>\n\n           <vra:materialSet><vra:display>\"marble, after bronze original\"</vra:display>\n             <vra:material>\"marble, after bronze original\"</vra:material>\n           </vra:materialSet>\n\n           <vra:relationSet><vra:display>\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:display>\n             <vra:relation pref=\"true\" relids=\"inu:dil-068f652d-3e46-4067-9698-084a9a20813a\" type=\"imageOf\">\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:relation>\n           </vra:relationSet>\n\n           <vra:stylePeriodSet><vra:display>Greek Classical Period</vra:display>\n             <vra:stylePeriod>Greek Classical Period</vra:stylePeriod>\n           </vra:stylePeriodSet>\n           <vra:techniqueSet><vra:display/>\n             <vra:technique/>\n           </vra:techniqueSet>\n\n           <vra:titleSet><vra:display>\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:display>\n             <vra:title pref=\"true\">\"Agias of Pharsala, the Pankratist, Son of Agnosios\". 3/4 view from right front</vra:title>\n           </vra:titleSet>\n\n           <vra:worktypeSet><vra:display>Sculpture</vra:display>\n             <vra:worktype vocab=\"local\">Sculpture</vra:worktype>\n           </vra:worktypeSet>\n         </vra:image>\n       </vra:vra>"},
        :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "", :headers => {})

      Delayed::Worker.new.work_off

      expect(ActionMailer::Base.deliveries.last.subject).to eq("Your Images record did not get published")
    end

end
