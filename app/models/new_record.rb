class NewRecord < ActiveRecord::Base
  belongs_to :job

  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ], :medium => ["1000x1000", :jpg] }

  before_create :add_minimal_xml

  include Validator

  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :job_id, :presence => true
  validates :filename, :uniqueness => true

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
