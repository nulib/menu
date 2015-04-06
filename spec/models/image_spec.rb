require 'rails_helper'

describe Image do

  it "fails to save without a parent Job" do
    image = Image.create

    expect( image.errors.messages ).not_to be_empty
  end

  it "saves with a parent Job" do
    job = create(:job_with_images)
    image = job.images.first

    expect( image.errors.messages ).to be_empty
  end

  it "has a non-empty xml attribute" do
    job = create(:job_with_images)
    image = job.images.first

    expect( image.image_xml ).to be_truthy
  end

  it "can return the directory path where the published image file should be moved" do
    job = create(:job)
    image = job.images.create( filename: 'test.tif', location: 'dropbox' )

    expect( image.completed_destination ).to eql( "#{MENU_CONFIG['images_dir']}/_completed/#{ job.job_id }" )
  end

  context "a new image" do
    it "has the default VRA XML in the xml attribute" do
      job = create(:job_with_images)
      image = job.images.first
      default_xml = File.read( 'app/assets/xml/vra_minimal.xml' )

      expect( image.image_xml ).to eql( default_xml )
    end

  end
end
