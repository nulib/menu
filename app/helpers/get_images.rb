module GetImages

  def self.current_images( location )
    path_length = location.split( '/' ).count
    imgs = []

    Dir.glob( "#{location}/**/*" ).each do |file|
      f = File.open( file )
      path = file.split( '/' )
      if File.file?( file ) && path.size == path_length + 2
        i = Image.find_by( filename: file, job_id: path[ -2 ] ) #, proxy: f
        if i == nil
          i = Image.create( filename: file, job_id: path[ -2 ], proxy: f )
        end
        imgs << i.id
      end
      f.close
    end

    # delete img records in db if they are no longer in the file system
    stale_records = Image.where.not(id: imgs)
    stale_records.each do |i|
      i.destroy
    end

  end
end
