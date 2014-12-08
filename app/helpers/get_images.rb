module GetImages

  @path_length = MENU_CONFIG["images_dir"].split( '/' ).count

  def self.current_images
    location = MENU_CONFIG["images_dir"]

    imgs = []
    dir_contents = Dir.glob( "#{location}/**/*" )
    dir_contents.delete_if { |dir| dir =~ /_completed/ }
    dir_contents.each do |file|
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
    job_id = path[ -2 ]

    if File.file?( file ) && path.size == @path_length + 2
      job = Job.find_or_create_by( job_id: job_id )
      i = Image.find_by( filename: File.basename( file ), job_id: job, location: File.dirname( file ))
      if i == nil
        file = prefix_file_name_with_job_id( file, job_id )
        f = File.open( file )
        i = job.images.create( filename: File.basename( file ), proxy: f, location: File.dirname( file ))
        f.close
      end
      return i.id
    end
  end

  def self.prefix_file_name_with_job_id( file, job_id )
    file_name_prefixed_by_job_id = if File.basename( file ).start_with?( job_id ) then
      File.basename( file )
    else
      "#{ job_id }_#{ File.basename( file )}"
    end
    file_name_full_path = "#{ File.dirname( file )}/#{ file_name_prefixed_by_job_id }"
    File.rename( file, file_name_full_path )
    file_name_full_path
  end

  def self.remove_job_id_from_file_name
    location = MENU_CONFIG[ 'images_dir' ]

    dir_contents = Dir.glob( "#{location}/**/*" )
    dir_contents.delete_if { |dir| dir =~ /_completed/ }
    dir_contents.each do |file|
      path = file.split( '/' )
      if File.file?( file ) && path.size == @path_length + 2 && File.basename( file ).start_with?( path[ -2 ])
        file_name = File.basename( file )
        original_file_name = file_name.slice( file_name.index( '_' ) + 1, file_name.length )
        File.rename( file, "#{ File.dirname( file )}/#{ original_file_name }")
      end
    end
  end

end
