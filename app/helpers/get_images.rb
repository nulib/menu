module GetImages

  def self.current_images( location )
    Dir.glob( "#{location}/*" ).each do |file|
      f = File.open( file )
      Image.create( filename: file, proxy: f )
      f.close
    end
  end

end