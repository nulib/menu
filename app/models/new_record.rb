class NewRecord < ActiveRecord::Base
  belongs_to :job

  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ], :original => ["1000x1000", :jpg] }

  before_create :add_minimal_xml

  include Validator

  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :job_id, :presence => true
  validates :filename, :uniqueness => true

  class << self
    def find_or_create_new_record( file_string )
      path = file_string.split( '/' )
      job_id = path[ -2 ]
      file = file_string.split("#{Rails.root}/")[1]
      if File.file?( file )
        job = Job.find_or_create_by( job_id: job_id )

        location = File.dirname( file ).sub(/#{Rails.root}\//, '')
        i = NewRecord.find_by( filename: File.basename( file ), job_id: job, location: location)
        if i == nil
          file = GetNewRecords.prefix_file_name_with_job_id( file, job_id )
          f = File.open( file )
          i = job.new_records.create( filename: File.basename( file ), proxy: f, location: location )
          f.close
        end

        return i.id
      end
    end

  handle_asynchronously :find_or_create_new_record

  end

  def job_id_display
    self.job.job_id
  end

  def path
    "#{location}/#{filename}"
  end

  def completed_destination
    completed_directory = "_completed"
    "#{MENU_CONFIG['images_dir']}/#{completed_directory}/#{ self.job.job_id }"
  end

  def valid_vra?
    true if validate_vra.empty?
  end

  def validate_vra
    doc = Nokogiri::XML(self.xml)

    invalid = []
    XSD.validate(doc).each do |error|
      invalid << "Validation error: #{error.message}"
    end
    required_fields = validate_required_fields(doc)
    invalid << required_fields unless required_fields.nil?

    invalid
  end

  private

  def add_minimal_xml
    self.xml = Nokogiri::XML.parse(File.read( "#{Rails.root}/app/assets/xml/vra_minimal.xml" )) if self.xml.nil?
  end

end
