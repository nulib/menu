require 'rails_helper'

describe GetImages do

  it "persists valid images to the DB" do
    loc = "#{Rails.root}/spec/dropbox_valid"
    path_length = loc.split( '/' ).count
    contents = Dir.glob( "#{loc}/**/*" )
    contents.select! do |entry|
      File.file?( entry ) || entry.split( '/' ).count == path_length + 2
    end
    
    GetImages.current_images( loc )
    expect( Image.all.count ).to eql( contents.count )
  end

  it "rejects invalid images from persisting to the DB" do
    loc = "#{Rails.root}/spec/dropbox_invalid"
    GetImages.current_images( loc )
    expect( Image.all.count ).to eql( 0 )
  end

end
