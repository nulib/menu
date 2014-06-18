module GetImages

  def self.current_images( location )
    path_length = location.split( '/' ).count
    Dir.glob( "#{location}/**/*" ).each do |file|
      f = File.open( file )
      path = file.split( '/' )
      next unless File.file?( file ) && path.size == path_length + 2
      Image.create( filename: file, job_id: path[ -2 ], proxy: f )
      f.close
    end
  end

end
