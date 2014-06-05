class Image < ActiveRecord::Base

  def self.valid_file?( file )
    # byebug
    valid_file_extensions = [ '.tif', '.tiff' ]
    # Ensure file is new to DB
    return false if Image.find_by( filename: file.filename, location: file.location )
    # Ensure file isn't a 'special' dir
    return false if file.filename == '.'
    return false if file.filename == '..'
    # Ensure file extension is in the list above
    return false unless valid_file_extensions.include?( File.extname( file.filename ).downcase )
    true
  end

end
