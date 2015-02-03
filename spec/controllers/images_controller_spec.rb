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
        job = Job.create( job_id: 123 )
        @image = job.images.create( filename: 'test.tif', location: 'dropbox' )
        doc = Nokogiri::XML( @image.image_xml )
        doc.xpath( '//vra:earliestDate' )[ 0 ].content = '0000'
        @image.image_xml = doc.to_xml
        @image.save
        allow(FileUtils).to receive(:mv)
        stub_request(:post, "https://127.0.0.1:3333/multiresimages/menu_publish").
             to_return(:status => 200, :body => "<response><returnCode>Publish successful</returnCode><pid>inu:dil-8a21a816-ac14-493c-a571-2be8e6dd4745</pid></response>", :headers => {})
      end

      it "generates an API call to Repository Images" do
        response = @controller.send( :dil_api_call, @image.image_xml, @image.path )
        expect( response ).to include( 'Publish successful' )
      end

      it "moves the image to the dropbox root once published" do
        expect(FileUtils).to receive("mv").with(@image.path, "#{@image.completed_destination}/#{@image.filename}")
        response = get( :publish, id: @image )
      end

      it "deletes the image" do
        expect do
          response = get( :publish, id: @image )
        end.to change(Image, :count).by(-1)
      end

      it "redirects to the site root" do
        expect( get( :publish, id: @image ) ).to redirect_to( root_url )
      end
    end

    context "with invalid vra" do
      it "fails gracefully" do
        stub_request(:post, "https://127.0.0.1:3333/multiresimages/menu_publish").
             to_return(:status => 200, :body => "<response><returnCode>Error</returnCode><description>Failed record</description></response>", :headers => {})
        @image = Image.create( job_id: 'test' )
        doc = Nokogiri::XML( @image.image_xml )
        doc.xpath( '//vra:earliestDate' )[ 0 ].content = '0000'
        @image.image_xml = doc.to_s
        @image.save

        response = get :publish, id: @image.id
        #expect( flash[:error] ).to eq( "Image not saved" )
        expect( flash[ :danger ]).to include( "Image not saved" )
      end
    end


  end
end
