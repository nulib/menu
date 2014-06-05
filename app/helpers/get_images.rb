module GetImages

  def self.current_images( location )
    file_list = get_file_list( location )
    image_list = valid_image_list( file_list )
    save_valid_image_list( image_list )
  end

  def self.get_file_list( location )
    file_list = []
    Dir.entries( location ).each do |file|
      file_list << Image.new( filename: file, location: location )
    end
    file_list
  end

  def self.valid_image_list( file_list )
    file_list.delete_if { |file| !Image.valid_file?( file ) }
    file_list.compact
  end

  def self.save_valid_image_list( image_list )
    image_list.each do |image|
      image.save!
    end
  end

end