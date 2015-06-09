require 'rails_helper'
require 'pp'

  def raw_post(action, params, body)
    @request.env['RAW_POST_DATA'] = body
    response = post(action, params)
    @request.env.delete('RAW_POST_DATA')
    response
  end


RSpec.describe ExistingRecordsController, :type => :controller do
  describe "Edit an existing record" do
    before do
      @controller = ExistingRecordsController.new
      stub_request(:get, "http://127.0.0.1:3333/multiresimages/get_vra?pid=inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60").
         to_return(:status => 200, :body => "<response><returnCode>Some XML for you</returnCode></response>", :headers => {})
    end

    it "gets the record's vra from Images app" do 
        @pid = "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60"
        response = @controller.send( :dil_api_get_vra, @pid )
        expect(response).to include("Some XML for you")
    end

    it "lets you update an existing record" do

      dil_record = "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60"
      xml = "<vra:vra xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:fn='http://www.w3.org/2005/xpath-functions' xmlns:marc='http://www.loc.gov/MARC21/slim' xmlns:mods='http://www.loc.gov/mods/v3' xmlns:vra='http://www.vraweb.org/vracore4.htm' xsi:schemaLocation='http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd' prefix='/vra:vra/vra:work:'>
      <vra:image id='inu-dil-2559730_w' refid='inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60'>
        <!--Agents-->
        <vra:agentSet>
            <vra:display>United States. War Production Board ; U.S. G.P.O.</vra:display>
            <vra:agent>
                <vra:name type='corporate' vocab='lcnaf'>Bon Bon</vra:name>
                <vra:attribution/>
            </vra:agent>
            <vra:agent>
                <vra:name type='corporate' vocab='lcnaf'>U.S. G.P.O.</vra:name>
            </vra:agent>
        </vra:agentSet>
        <vra:culturalContextSet>
            <vra:display/>
            <vra:culturalContext/>
        </vra:culturalContextSet>
        <!--Dates-->
        <vra:dateSet>
            <vra:display>1942</vra:display>
            <vra:date type='creation'>
                <vra:earliestDate>1942</vra:earliestDate>
            </vra:date>
        </vra:dateSet>
        <!-- Titles -->
        <vra:titleSet>
            <vra:display>'Every man, woman and child is a partner'</vra:display>
            <vra:title pref='true'>'Every man, woman and child is a partner'</vra:title>
        </vra:titleSet>
        <vra:worktypeSet>
            <vra:display/>
            <vra:worktype/>
        </vra:worktypeSet>
      </vra:image>
      </vra:vra>"
      stub_request(:get, "http://127.0.0.1:3333/multiresimages/get_vra?pid=inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60").
         to_return(:status => 200, :body => "<response><returnCode>#{xml}</returnCode></response>", :headers => {})
    
      response = get( :edit, :pid => "#{dil_record}")

      expect(response).to_not have_content("Dana Sculley")

      xml.sub!('Bon Bon', 'Dana Sculley')

      stub_request(:put, "http://127.0.0.1:3333/multiresimages/update_vra").
         with(:body => {"pid"=>"inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60", "xml"=>"<vra:vra xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:fn=\"http://www.w3.org/2005/xpath-functions\" xmlns:marc=\"http://www.loc.gov/MARC21/slim\" xmlns:mods=\"http://www.loc.gov/mods/v3\" xmlns:vra=\"http://www.vraweb.org/vracore4.htm\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd\">\n    <vra:image id=\"inu-dil-2559730_w\" refid=\"inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60\">\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:display>United States. War Production Board ; U.S. G.P.O.</vra:display>\n            <vra:agent>\n                <vra:name type=\"corporate\" vocab=\"lcnaf\">Dana Sculley</vra:name>\n                <vra:attribution/>\n            </vra:agent>\n            <vra:agent>\n                <vra:name type=\"corporate\" vocab=\"lcnaf\">U.S. G.P.O.</vra:name>\n            </vra:agent>\n        </vra:agentSet>\n        <vra:culturalContextSet>\n            <vra:display/>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display>1942</vra:display>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>1942</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet>\n        <!-- Titles -->\n        <vra:titleSet>\n            <vra:display>'Every man, woman and child is a partner'</vra:display>\n            <vra:title pref=\"true\">'Every man, woman and child is a partner'</vra:title>\n        </vra:titleSet>\n        <vra:worktypeSet>\n            <vra:display/>\n            <vra:worktype/>\n        </vra:worktypeSet>\n    </vra:image>\n</vra:vra>"},
              :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'2997', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})
      
      resp = raw_post( :update, {:pid => "#{dil_record}"},  "<vra:vra xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:fn=\"http://www.w3.org/2005/xpath-functions\" xmlns:marc=\"http://www.loc.gov/MARC21/slim\" xmlns:mods=\"http://www.loc.gov/mods/v3\" xmlns:vra=\"http://www.vraweb.org/vracore4.htm\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd\">\n    <vra:image id=\"inu-dil-2559730_w\" refid=\"inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60\">\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:display>United States. War Production Board ; U.S. G.P.O.</vra:display>\n            <vra:agent>\n                <vra:name type=\"corporate\" vocab=\"lcnaf\">Dana Sculley</vra:name>\n                <vra:attribution/>\n            </vra:agent>\n            <vra:agent>\n                <vra:name type=\"corporate\" vocab=\"lcnaf\">U.S. G.P.O.</vra:name>\n            </vra:agent>\n        </vra:agentSet>\n        <vra:culturalContextSet>\n            <vra:display/>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display>1942</vra:display>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>1942</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet>\n        <!-- Titles -->\n        <vra:titleSet>\n            <vra:display>'Every man, woman and child is a partner'</vra:display>\n            <vra:title pref=\"true\">'Every man, woman and child is a partner'</vra:title>\n        </vra:titleSet>\n        <vra:worktypeSet>\n            <vra:display/>\n            <vra:worktype/>\n        </vra:worktypeSet>\n    </vra:image>\n</vra:vra>" )

      expect(resp.body).to eq("{\"localName\":\"#{root_url}\"}") 

      stub_request(:get, "http://localhost:8983/fedora/objects/inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60/datastreams/VRA/content").to_return(:status => 200, :body => "#{xml}", :headers => {})
      uri = URI('http://localhost:8983/fedora/objects/inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60/datastreams/VRA/content')
      updated_vra = Net::HTTP.get(uri)

      expect(updated_vra ).to have_content("Dana Sculley")

    end

    it "won't allow invalid updates to a record" do 
      dil_record = "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60"
      xml = "<vra:vra xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:fn='http://www.w3.org/2005/xpath-functions' xmlns:marc='http://www.loc.gov/MARC21/slim' xmlns:mods='http://www.loc.gov/mods/v3' xmlns:vra='http://www.vraweb.org/vracore4.htm' xsi:schemaLocation='http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd' prefix='/vra:vra/vra:work:'>
      <vra:image id='inu-dil-2559730_w' refid='inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60'>
        <!--Agents-->
        <vra:agentSet>
            <vra:display>United States. War Production Board ; U.S. G.P.O.</vra:display>
            <vra:agent>
                <vra:name type='corporate' vocab='lcnaf'></vra:name>
                <vra:attribution/>
            </vra:agent>
            <vra:agent>
                <vra:name type='corporate' vocab='lcnaf'>U.S. G.P.O.</vra:name>
            </vra:agent>
        </vra:agentSet>
        <vra:culturalContextSet>
            <vra:display/>
            <vra:culturalContext/>
        </vra:culturalContextSet>
        <!--Dates-->
        <vra:dateSet>
            <vra:display>1942</vra:display>
            <vra:date type='creation'>
                <vra:earliestDate>1942</vra:earliestDate>
            </vra:date>
        </vra:dateSet>
        <!-- Titles -->
        <vra:titleSet>
            <vra:display>'Every man, woman and child is a partner'</vra:display>
            <vra:title pref='true'>'Every man, woman and child is a partner'</vra:title>
        </vra:titleSet>
        <vra:worktypeSet>
            <vra:display/>
            <vra:worktype/>
        </vra:worktypeSet>
      </vra:image>
      </vra:vra>"
      stub_request(:get, "http://127.0.0.1:3333/multiresimages/get_vra?pid=inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60").
         to_return(:status => 200, :body => "<response><returnCode>#{xml}</returnCode></response>", :headers => {})
    
      response = get( :edit, :pid => "#{dil_record}")

       stub_request(:put, "http://127.0.0.1:3333/multiresimages/update_vra").
         with(:body => {"pid"=>"inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60", "xml"=>"<vra:vra xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:fn=\"http://www.w3.org/2005/xpath-functions\" xmlns:marc=\"http://www.loc.gov/MARC21/slim\" xmlns:mods=\"http://www.loc.gov/mods/v3\" xmlns:vra=\"http://www.vraweb.org/vracore4.htm\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd\">\n      <vra:image id=\"inu-dil-2559730_w\" refid=\"inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60\">\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:display>United States. War Production Board ; U.S. G.P.O.</vra:display>\n            <vra:agent>\n                <vra:name type=\"corporate\" vocab=\"lcnaf\"></vra:name>\n                <vra:attribution/>\n            </vra:agent>\n            <vra:agent>\n                <vra:name type=\"corporate\" vocab=\"lcnaf\">U.S. G.P.O.</vra:name>\n            </vra:agent>\n        </vra:agentSet>\n        <vra:culturalContextSet>\n            <vra:display/>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display>1942</vra:display>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>1942</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet>\n        <!-- Titles -->\n        <vra:titleSet>\n            <vra:display>'Every man, woman and child is a partner'</vra:display>\n            <vra:title pref=\"true\">'Every man, woman and child is a partner'</vra:title>\n        </vra:titleSet>\n        <vra:worktypeSet>\n            <vra:display/>\n            <vra:worktype/>\n        </vra:worktypeSet>\n      </vra:image>\n      </vra:vra>"},
              :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'3022', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'})
      
      resp = raw_post( :update, {:pid => "#{dil_record}"},  xml )
      expect(response.status).to eq 400
    end
  end
end
