require 'rails_helper'
require 'pp'


  def raw_post(action, params, body)
    @request.env['RAW_POST_DATA'] = body
    response = post(action, params)
    @request.env.delete('RAW_POST_DATA')
    response
  end

RSpec.describe NewRecordsController, :type => :controller do

  before do
    sign_in FactoryGirl.create(:user)
  end

  describe "CREATE new_record" do

    it "creates a NewRecord" do
      expect do
        post(:create, new_record: {filename: '001_test.tif', location: 'gandalf', job_id: 'test'})
      end.to change(NewRecord, :count).by(1)
    end
  end

  context "with an existing new_record" do
    before :each do
      @new_record = NewRecord.create!( xml: '<vra></vra>', job_id: 'test' )
    end

    describe "DESTROY new_record" do

      it "deletes the NewRecord" do
        expect do
          delete(:destroy, :id => @new_record.to_param)
        end.to change(NewRecord, :count).by(-1)
      end
    end

    describe "UPDATE new_record" do

      it "locates the requested new_record" do
        put(:update, id: @new_record, new_record: {filename: 'different.tif', location: 'gandalf2'})
        expect(assigns(:new_record)).to eq(@new_record)
      end

      it "changes the new_record's attributes" do
        put(:update, id: @new_record, new_record: {filename: 'different.tif', location: 'gandalf2'})
        @new_record.reload
        expect(@new_record.filename).to eq('different.tif')
        expect(@new_record.location).to eq('gandalf2')
      end

      it "redirects to the updated new_record" do
        put(:update, id: @new_record, new_record: {filename: 'different.tif', location: 'gandalf2'})
        expect(response).to redirect_to(@new_record)
      end
    end

    describe "SAVE_XML new_record" do

      it "saves the edited xml to the new_record object" do
        request.env['content_type'] = 'application/xml'
        request.env['RAW_POST_DATA'] =  '<vra>New</vra>'
        post(:save_xml, id: @new_record, format: 'xml' )
        @new_record.reload
        expect(@new_record.xml.to_s).to eq('<vra>New</vra>')
      end

    end
  end

  describe "publishes a new_record" do

    context "with valid vra" do
      before do
        @controller = NewRecordsController.new
        job = create(:job)
        @new_record = job.new_records.create( filename: '001_test.tif', location: 'dropbox' )
        doc = Nokogiri::XML( @new_record.xml )
        doc.xpath( '//vra:earliestDate' )[ 0 ].content = 'present'
        doc.xpath( '//vra:agent//vra:name' )[ 0 ].content = 'Sculley'
        doc.xpath( '//vra:title' )[ 0 ].content = 'X-Files'

        @new_record.xml = doc.to_xml
        @accession_nbr = TransformXML.get_accession_nbr( @new_record.xml )
         allow(FileUtils).to receive(:mv)

         stub_request(:post, "https://127.0.0.1:3331/multiresimages").
              to_return(:status => 200, :body => "<response><returnCode>Publish successful</returnCode><pid>inu:dil-8a21a816-ac14-493c-a571-2be8e6dd4745</pid></response>", :headers => {})
      end

      it "generates a multiresimages post to Repository Images" do
        response = @controller.send( :dil_multiresimages_post, @new_record.xml, @new_record.path, @accession_nbr )

        expect( response ).to be_instance_of(Delayed::Backend::ActiveRecord::Job)
      end

      it "returns root_url upon success so that ajax can redirect" do
        resp = raw_post( :publish, {:id => @new_record.id},  @new_record.xml )
        job_url = "#{root_url}jobs/#{@new_record.job_id}"

        expect(resp.body).to include(job_url)
      end
    end

    context "with invalid vra" do
      it "fails gracefully" do
        stub_request(:post, "http://127.0.0.1:3331/multiresimages").to_return(:status => 200, :body => "<response><returnCode>Error</returnCode><description>Failed record</description></response>", :headers => {})
        @new_record = NewRecord.create!( filename: '001_test.tif', job_id: 'test' )
        doc = Nokogiri::XML( @new_record.xml )
        doc.xpath( '//vra:earliestDate' )[ 0 ].content = 'pres'
        raw_post(:publish, {:id => @new_record.id}, doc.to_s )
        expect(response.status).to eq 400
      end
    end

  end
end
