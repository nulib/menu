class Image < ActiveRecord::Base

  def self.get_files
    dir_location = "davies"
    Dir.entries( dir_location ).each do |file|
      if Image.valid_file?( file, dir_location )
        Image.create!( filename: file, location: dir_location )
      end
    end
  end

  private

    def self.valid_file?( file, dir_location )
      # byebug
      valid_file_extensions = [ '.tif', '.tiff' ]
      # Ensure file is new to DB
      return false if Image.find_by( filename: file, location: dir_location )
      # Ensure file isn't a 'special' dir
      return false if file == '.'
      return false if file == '..'
      # Ensure file extension is in the list above
      return false unless valid_file_extensions.include?( File.extname( file ) )
      true
    end
end
