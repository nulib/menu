require 'rails_helper'

RSpec.describe ImagesController, :type => :controller do
  describe "CREATE image" do

    it "creates a new Image" do
      expect do
        post(:create, image: {filename: 'test.tif', location: 'gandalf', job_id: 'test'})
      end.to change(Image, :count).by(1)
    end
  end

  context "with an existing image" do
    before :each do
      @image = Image.create!( image_xml: '<vra></vra>', job_id: 'test' )
    end

    describe "DESTROY image" do
  
      it "deletes the Image" do
        expect do 
          delete(:destroy, :id => @image.to_param)
        end.to change(Image, :count).by(-1)
      end
    end
  
    describe "UPDATE image" do
  
      it "locates the requested image" do
        put(:update, id: @image, image: {filename: 'different.tif', location: 'gandalf2'})
        expect(assigns(:image)).to eq(@image)
      end
  
      it "changes the images's attributes" do
        put(:update, id: @image, image: {filename: 'different.tif', location: 'gandalf2'})
        @image.reload
        expect(@image.filename).to eq('different.tif')
        expect(@image.location).to eq('gandalf2')
      end
  
      it "redirects to the updated image" do
        put(:update, id: @image, image: {filename: 'different.tif', location: 'gandalf2'})
        expect(response).to redirect_to(@image)
      end
    end

    describe "SAVE_XML image" do

      it "saves the edited xml to the image object" do
        request.env['content_type'] = 'application/xml' 
        request.env['RAW_POST_DATA'] =  '<vra>New</vra>'
        post(:save_xml, id: @image, format: 'xml' )
        @image.reload
        expect(@image.image_xml.to_s).to eq('<vra>New</vra>')
      end

    end
  end

  describe "publishes a record" do
    context "with valid vra" do
      before do
        @controller = ImagesController.new
        @image = Image.create( job_id: 'test' )
        @image.image_xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<vra:vra xmlns:madsrdf=\"http://www.loc.gov/mads/rdf/v1#\"\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\" xmlns:marc=\"http://www.loc.gov/MARC21/slim\"\n    xmlns:mods=\"http://www.loc.gov/mods/v3\" xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n    xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd\">\n   <vra:image>\n      \n      <!--Agents-->\n       <vra:agentSet>\n         <vra:display></vra:display>\n         <vra:agent>\n            <vra:name type=\"corporate\" vocab=\"lcnaf\"></vra:name>\n            <vra:attribution/>\n            <vra:role vocab=\"RDA\"/>\n         </vra:agent>\n         <vra:agent>\n            <vra:name type=\"corporate\" vocab=\"lcnaf\"></vra:name>\n         </vra:agent>\n      </vra:agentSet>\n\n      <!--Cultural Context-->\n      <vra:culturalContextSet>\n         <vra:display/>\n         <vra:culturalContext/>\n      </vra:culturalContextSet>\n\n      <!--Dates-->\n      <vra:dateSet>\n         <vra:display/>\n         <vra:date type=\"creation\">\n            <vra:earliestDate></vra:earliestDate>\n         </vra:date>\n      </vra:dateSet>\n\n      <!--Description-->\n      <vra:descriptionSet>\n         <vra:display></vra:display>\n         <vra:notes></vra:notes>\n         <vra:description></vra:description>\n      </vra:descriptionSet>\n\n      <!--Inscription-->\n      <vra:inscriptionSet>\n         <vra:display/>\n         <vra:inscription>\n            <vra:text></vra:text>\n         </vra:inscription>\n      </vra:inscriptionSet>\n\n      <!--Location-->\n      <vra:locationSet>\n         <vra:display></vra:display>\n         <vra:location type=\"creation\">\n            <vra:name type=\"geographic\"></vra:name>\n         </vra:location>\n         <vra:location type=\"repository\">\n            <vra:name type=\"geographic\"></vra:name>\n         </vra:location>\n         <vra:location>\n            <vra:refid source=\"DIL\"></vra:refid>\n            <vra:refid source=\"Voyager\"></vra:refid>\n         </vra:location>\n      </vra:locationSet>\n\n      <!--Materials-->\n      <vra:materialSet>\n         <vra:display></vra:display>\n         <vra:material></vra:material>\n      </vra:materialSet>\n\n      <!--Measurements-->\n      <vra:measurementsSet>\n         <vra:display></vra:display>\n         <vra:measurements></vra:measurements>\n      </vra:measurementsSet>\n\n      <!--Relation-->\n      <vra:relationSet>\n         <vra:display/>\n         <vra:relation pref=\"true\" type=\"imageOf\" relids=\"\"/>\n      </vra:relationSet>\n\n      <!--Rights-->\n      <vra:rightsSet>\n         <vra:display></vra:display>\n         <vra:rights>\n            <vra:rightsHolder></vra:rightsHolder>\n            <vra:text></vra:text>\n         </vra:rights>\n      </vra:rightsSet>\n\n      <!--Style Period-->\n      <vra:stylePeriodSet>\n         <vra:display/>\n         <vra:stylePeriod/>\n      </vra:stylePeriodSet>\n\n      <!--Subjects-->\n      <vra:subjectSet>\n         <vra:display></vra:display>\n         <vra:subject>\n            <vra:term type=\"geographicPlace\" vocab=\"lcnaf\"></vra:term>\n         </vra:subject>\n         <vra:subject>\n            <vra:term type=\"personalName\" vocab=\"lcnaf\"></vra:term>\n         </vra:subject>\n         <vra:subject>\n            <vra:term type=\"personalName\" vocab=\"lcnaf\"></vra:term>\n         </vra:subject>\n         <vra:subject>\n            <vra:term type=\"otherTopic\"></vra:term>\n         </vra:subject>\n         <vra:subject>\n            <vra:term type=\"descriptiveTopic\" vocab=\"lcsh\"></vra:term>\n         </vra:subject>\n      </vra:subjectSet>\n\n      <!--Technique-->\n      <vra:techniqueSet>\n         <vra:display/>\n         <vra:technique/>\n      </vra:techniqueSet>\n\n      <!--Textref-->\n      <vra:textrefSet>\n         <vra:display/>\n         <vra:textref/>\n      </vra:textrefSet>\n\n      <!-- Titles -->\n      <vra:titleSet>\n         <vra:display></vra:display>\n         <vra:title pref=\"true\"></vra:title>\n      </vra:titleSet>\n\n      <!--Work Type-->\n      <vra:worktypeSet>\n         <vra:display></vra:display>\n         <vra:worktype></vra:worktype>\n      </vra:worktypeSet>\n   </vra:image>\n</vra:vra>\n    \n"
        stub_request(:post, "https://127.0.0.1:3333/multiresimages/menu_publish").
             with(:body => {"path"=>"/", "xml"=>"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<vra:vra xmlns:madsrdf=\"http://www.loc.gov/mads/rdf/v1#\"\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\" xmlns:marc=\"http://www.loc.gov/MARC21/slim\"\n    xmlns:mods=\"http://www.loc.gov/mods/v3\" xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n    xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd\">\n   <vra:image>\n      \n      <!--Agents-->\n       <vra:agentSet>\n         <vra:display></vra:display>\n         <vra:agent>\n            <vra:name type=\"corporate\" vocab=\"lcnaf\"></vra:name>\n            <vra:attribution/>\n            <vra:role vocab=\"RDA\"/>\n         </vra:agent>\n         <vra:agent>\n            <vra:name type=\"corporate\" vocab=\"lcnaf\"></vra:name>\n         </vra:agent>\n      </vra:agentSet>\n\n      <!--Cultural Context-->\n      <vra:culturalContextSet>\n         <vra:display/>\n         <vra:culturalContext/>\n      </vra:culturalContextSet>\n\n      <!--Dates-->\n      <vra:dateSet>\n         <vra:display/>\n         <vra:date type=\"creation\">\n            <vra:earliestDate></vra:earliestDate>\n         </vra:date>\n      </vra:dateSet>\n\n      <!--Description-->\n      <vra:descriptionSet>\n         <vra:display></vra:display>\n         <vra:notes></vra:notes>\n         <vra:description></vra:description>\n      </vra:descriptionSet>\n\n      <!--Inscription-->\n      <vra:inscriptionSet>\n         <vra:display/>\n         <vra:inscription>\n            <vra:text></vra:text>\n         </vra:inscription>\n      </vra:inscriptionSet>\n\n      <!--Location-->\n      <vra:locationSet>\n         <vra:display></vra:display>\n         <vra:location type=\"creation\">\n            <vra:name type=\"geographic\"></vra:name>\n         </vra:location>\n         <vra:location type=\"repository\">\n            <vra:name type=\"geographic\"></vra:name>\n         </vra:location>\n         <vra:location>\n            <vra:refid source=\"DIL\"></vra:refid>\n            <vra:refid source=\"Voyager\"></vra:refid>\n         </vra:location>\n      </vra:locationSet>\n\n      <!--Materials-->\n      <vra:materialSet>\n         <vra:display></vra:display>\n         <vra:material></vra:material>\n      </vra:materialSet>\n\n      <!--Measurements-->\n      <vra:measurementsSet>\n         <vra:display></vra:display>\n         <vra:measurements></vra:measurements>\n      </vra:measurementsSet>\n\n      <!--Relation-->\n      <vra:relationSet>\n         <vra:display/>\n         <vra:relation pref=\"true\" type=\"imageOf\" relids=\"\"/>\n      </vra:relationSet>\n\n      <!--Rights-->\n      <vra:rightsSet>\n         <vra:display></vra:display>\n         <vra:rights>\n            <vra:rightsHolder></vra:rightsHolder>\n            <vra:text></vra:text>\n         </vra:rights>\n      </vra:rightsSet>\n\n      <!--Style Period-->\n      <vra:stylePeriodSet>\n         <vra:display/>\n         <vra:stylePeriod/>\n      </vra:stylePeriodSet>\n\n      <!--Subjects-->\n      <vra:subjectSet>\n         <vra:display></vra:display>\n         <vra:subject>\n            <vra:term type=\"geographicPlace\" vocab=\"lcnaf\"></vra:term>\n         </vra:subject>\n         <vra:subject>\n            <vra:term type=\"personalName\" vocab=\"lcnaf\"></vra:term>\n         </vra:subject>\n         <vra:subject>\n            <vra:term type=\"personalName\" vocab=\"lcnaf\"></vra:term>\n         </vra:subject>\n         <vra:subject>\n            <vra:term type=\"otherTopic\"></vra:term>\n         </vra:subject>\n         <vra:subject>\n            <vra:term type=\"descriptiveTopic\" vocab=\"lcsh\"></vra:term>\n         </vra:subject>\n      </vra:subjectSet>\n\n      <!--Technique-->\n      <vra:techniqueSet>\n         <vra:display/>\n         <vra:technique/>\n      </vra:techniqueSet>\n\n      <!--Textref-->\n      <vra:textrefSet>\n         <vra:display/>\n         <vra:textref/>\n      </vra:textrefSet>\n\n      <!-- Titles -->\n      <vra:titleSet>\n         <vra:display></vra:display>\n         <vra:title pref=\"true\"></vra:title>\n      </vra:titleSet>\n\n      <!--Work Type-->\n      <vra:worktypeSet>\n         <vra:display></vra:display>\n         <vra:worktype></vra:worktype>\n      </vra:worktypeSet>\n   </vra:image>\n</vra:vra>\n    \n"},
                  :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'7992', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
             to_return(:status => 200, :body => "<response><returnCode>Publish successful</returnCode><pid>inu:dil-8a21a816-ac14-493c-a571-2be8e6dd4745</pid></response>", :headers => {})
      end

      it "generates an API call to Repository Images" do
        response = @controller.send( :dil_api_call, @image.image_xml, @image.path )
        expect( response ).to include( 'Publish successful' )
      end

      it "saves the returned PID to the image" do
        response = get( :publish_record, id: @image )
        @image.reload
        expect( @image.image_pid ).to eq( 'inu:dil-8a21a816-ac14-493c-a571-2be8e6dd4745' )
      end

      it "redirects to the site root" do
        expect( get( :publish_record, id: @image ) ).to redirect_to( root_url )
      end
    end

    context "with invalid vra" do
      it "fails gracefully" do
        stub_request(:post, "https://127.0.0.1:3333/multiresimages/menu_publish").
             to_return(:status => 200, :body => "<response><returnCode>Error</returnCode><description>Failed record</description></response>", :headers => {})
        @image = Image.create( job_id: 'test' )

        response = get :publish_record, id: @image.id
        expect( flash[:error] ).to eq( "Image not saved" )
      end
    end

    
  end
end
