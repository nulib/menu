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
end
