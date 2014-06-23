require 'rails_helper'
require 'fakefs/spec_helpers'

describe GetImages do

  it "persists valid images to the DB" do
    GetImages.current_images
    expect( Image.all.count ).to eql( 3 )
  end

  it "rejects invalid images from persisting to the DB" do
    pending "set up factory_girl_rails to create an invalid image"
    GetImages.current_images
    expect( Image.all.count ).to eql( 0 )
  end



  it "removes stale images" do
    pending "create images in db that don't exist in file system"
  end

end
