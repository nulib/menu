require 'rails_helper'
require 'pp'


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
  end
end
