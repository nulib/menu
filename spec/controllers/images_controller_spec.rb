require 'rails_helper'

RSpec.describe ImagesController, :type => :controller do
  before :each do
    @image = Image.create!
  end

  describe "CREATE image" do

    it "creates a new Image" do
      expect do 
        post(:create, :image => {filename: 'test.tif', location: 'gandalf'})
      end.to change(Image, :count).by(1)
    end

  describe "DESTROY image" do

    it "deletes the Image" do
      expect do 
        delete(:destroy, :id => @image.to_param)
      end.to change(Image, :count).by(-1)
    end
  end
end
