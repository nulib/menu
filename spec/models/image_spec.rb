require 'rails_helper'

describe Image do
  it "has a non-empty xml attribute" do
    @image = Image.create( job_id: 'test' )
    expect( @image.image_xml ).to be_truthy
  end

  it "can return the directory path where the published image file should be moved" do
    @job = Job.create( job_id: 123 )
    @image = @job.images.create( filename: 'test.tif', location: 'dropbox' )
    expect( @image.completed_destination ).to eql( "#{MENU_CONFIG['images_dir']}/_completed/#{ @job.job_id }" )
  end

  context "a new image" do
    it "has the default VRA XML in the xml attribute" do
      @image = Image.create( job_id: 'test' )
      default_xml = File.read( 'app/assets/xml/vra_minimal.xml' )
      expect( @image.image_xml ).to eql( default_xml )
    end
  end
end
