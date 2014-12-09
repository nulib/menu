require 'rails_helper'

describe GetImages do

  it "persists valid images to the DB" do
    GetImages.add_job_id_to_random_files
    GetImages.current_images
    expect( Image.all.count ).to eql( 12 )
    GetImages.remove_job_id_from_file_name
  end

  it "rejects invalid images from persisting to the DB" do
    `touch #{Rails.root}/spec/dropbox_invalid/invalid.tiff`
    GetImages.find_or_create_image("#{Rails.root}/spec/dropbox_invalid/invalid.tiff")
    expect( Image.all.count ).to eql( 0 )
  end

  # The empty array sent to the remove_stale_images function implies that there are no
  # image files on the file system, so the Image model that was just created is stale
  it "removes stale images" do
    Image.create(filename: "cool_test", job_id: "98765")
    GetImages.remove_stale_images( [] )
    expect( Image.all.count ).to eql( 0 )
  end

end
