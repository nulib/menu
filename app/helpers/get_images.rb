module GetImages

  def self.current_images( location )
    Dir.glob( "#{location}/**/*" ).each do |file|
      f = File.open( file )
      path = file.split( '/' )
      next unless File.file?( file ) && path.size == 4
      Image.create( filename: file, job_id: path[ -2 ], proxy: f )
      f.close
    end
  end

end
