module GetImages

  @path_length = MENU_CONFIG["images_dir"].split( '/' ).count

  def self.current_images
    location = MENU_CONFIG["images_dir"]

    imgs = []
    subdirs = Dir.glob( "#{location}/**/*" )
    subdirs.delete_if { |dir| dir =~ /_completed/ }
    subdirs.each do |file|
      imgs << find_or_create_image(file)
    end

    remove_stale_images(imgs)

  end


  def self.remove_stale_images( file_system_image_ids )
    stale_records = Image.where.not(id: file_system_image_ids)
    stale_records.each do |i|
      i.destroy
    end
  end


  def self.find_or_create_image( file )
    path = file.split( '/' )

    if File.file?( file ) && path.size == @path_length + 2
      job = Job.find_or_create_by( job_id: path[ -2 ])
      i = Image.find_by( filename: File.basename( file ), job_id: job, location: File.dirname( file ))
      if i == nil
        f = File.open( file )
        i = job.images.create( filename: File.basename( file ), proxy: f, location: File.dirname( file ))
        f.close
      end
      return i.id
    end
  end

end
