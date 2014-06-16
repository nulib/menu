require 'rails_helper'

describe GetImages do

  it "persists valid images to the DB" do
    loc = "#{Rails.root}/spec/dropbox_valid"
    GetImages.current_images( loc )
    expect( Image.all.count ).to eql( Dir.glob( "#{loc}/*" ).count )
  end

  it "rejects invalid images from persisting to the DB" do
    loc = "#{Rails.root}/spec/dropbox_invalid"
    GetImages.current_images( loc )
    expect( Image.all.count ).to eql( 0 )
  end

end
