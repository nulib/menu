module GetNewRecords

  @path_length = MENU_CONFIG["images_dir"].split( '/' ).count

    def self.current_new_records
    location = MENU_CONFIG["images_dir"]
    records = []
    dir_contents = Dir.glob( "#{location}/**/*" )
    dir_contents.delete_if { |dir| dir =~ /_completed/ }
    dir_contents.each do |file|
      records << find_or_create_new_record(file)
    end

    remove_stale_new_records(records)

  end

  def self.remove_stale_new_records( file_system_new_record_ids )
    stale_records = NewRecord.where.not(id: file_system_new_record_ids)
    stale_records.each do |i|
      i.destroy
    end
  end


  def self.find_or_create_new_record( file )
    path = file.split( '/' )
    job_id = path[ -2 ]

    if File.file?( file ) && path.size == @path_length + 2
      job = Job.find_or_create_by( job_id: job_id )
      i = NewRecord.find_by( filename: File.basename( file ), job_id: job, location: File.dirname( file ))
      if i == nil
        file = prefix_file_name_with_job_id( file, job_id )
        f = File.open( file )
        i = job.new_records.create( filename: File.basename( file ), proxy: f, location: File.dirname( file ))
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

  def self.add_job_id_to_random_files
    location = MENU_CONFIG[ 'images_dir' ]

    dir_contents = Dir.glob( "#{location}/**/*" )
    dir_contents.delete_if { |dir| dir =~ /_completed/ }
    sampled_dir_contents = dir_contents.sample( 4 )
    sampled_dir_contents.each do |file|
      path = file.split( '/' )
      if File.file?( file ) && path.size == @path_length + 2 && !File.basename( file ).start_with?( path[ -2 ])
        prefixed_file_name = "#{ File.dirname( file )}/#{ path[ -2 ]}_#{ File.basename( file )}"
        File.rename( file, prefixed_file_name )
      end
    end
  end

end
