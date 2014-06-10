require 'rails_helper'

describe Image do
  it "accepts a valid file" do
    valid_files = %w( image01.tif _image02.tif image03.tiff IMAGE04.TIF IMAGE05.TIFF )
    valid_images = valid_files.map { |file| Image.new( filename: file )}
    valid_images.each do |image|
      expect( Image.valid_file?( image )).to be true
    end
  end

  it "rejects an invalid file" do
    valid_image = Image.new( filename: "image01.tif" )
    valid_image.save!

    invalid_files = %w( image01.jpg image01.psd image01.gif image02.GIF . .. )
    invalid_images = invalid_files.map { |file| Image.new( filename: file )}
    invalid_images << valid_image
    invalid_images.each do |image|
      expect( Image.valid_file?( image )).to be false
    end
  end
end