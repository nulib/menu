require 'rails_helper'

describe GetImages do
  context "within a location" do
    before( :each ) do
      @file_list = [ 'image01.tif', 'image02.tif', 'image03.tif', 'image04.jpg' ]
      @loc = Rails.root.join( 'test_dropbox' )
  
      @new_dir = Dir.mkdir( @loc )
      Dir.chdir( @loc )
  
      @file_list.each do |file|
        File.new( file, "w" )
      end
    end
  
    it "gets a list of files" do
      files = GetImages.get_file_list( @loc )
      expect( files.map { |f| f.filename } ).to match_array( [ '.', '..' ] + @file_list )
    end
  
    after( :each ) do
      @file_list.each do |file|
        File.delete( file )
      end
  
      Dir.rmdir( @loc )
    end
  end

  it "validates each file in a list" do
    bad_file_list = %w( image01.jpg image01.tif image01.psd image01 )
    bad_image_list = []
    bad_file_list.each do |file|
      bad_image_list << Image.new( filename: file )
    end
    good_file_list = %w( image01.tif )

    image_list = GetImages.valid_image_list( bad_image_list )
    expect( image_list.map { |f| f.filename }).to match_array( good_file_list )
  end

  it "saves valid images" do
    good_file_list = %w( image01.tif image02.tif image03.tif )
    good_image_list = []
    good_file_list.each do |file|
      good_image_list << Image.new( filename: file )
    end
    GetImages.save_valid_image_list( good_image_list )
    expect( Image.all ).to match_array( good_image_list )
  end

end