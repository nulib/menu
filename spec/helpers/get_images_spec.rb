require 'rails_helper'

describe GetImages do

  it "persists valid images to the DB" do
    GetImages.current_images
    expect( Image.all.count ).to eql( 3 )
  end

  it "rejects invalid images from persisting to the DB" do
    `touch #{Rails.root}/spec/dropbox_invalid/invalid.tiff`
    GetImages.find_or_create_image("#{Rails.root}/spec/dropbox_invalid/invalid.tiff")
    expect( Image.all.count ).to eql( 0 )
  end

  xit "removes stale images" do
    pending "create images in db that don't exist in file system"
  end

end
