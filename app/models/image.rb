class Image < ActiveRecord::Base

  def self.get_files
    dir_location = "davies"
    Dir.entries( dir_location ).each do |file|
      if Image.verify_file( file, dir_location )
        Image.create( filename: file, location: dir_location )
      end
    end
  end

  private

    def self.verify_file( file, dir_location )
      if Image.find_by( filename: file, location: dir_location ) ||
        file == '.' ||
        file == '..' ||
        File.extname( file ) !=~ /tif|tiff/i
      end
    end
end
