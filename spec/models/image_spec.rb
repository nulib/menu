require 'rails_helper'

describe Image do
  it "has a non-empty xml attribute" do
    @image = Image.create( job_id: 'test' )
    expect( @image.image_xml ).to be_truthy
  end

  it "can return the directory path where the published image file should be moved" do
    @image = Image.create( filename: 'test.tif', location: 'dropbox', job_id: 'test' )
    expect( @image.completed_destination ).to eql( 'dropbox/_completed/test' )
  end

  context "a new image" do
    it "has the default VRA XML in the xml attribute" do
      @image = Image.create( job_id: 'test' )
      default_xml = File.read( 'app/assets/xml/vra_minimal.xml' )
      expect( @image.image_xml ).to eql( default_xml )
    end
  end
end
