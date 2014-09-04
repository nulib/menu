class Image < ActiveRecord::Base

  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ], :medium => ["1000x1000", :jpg] }

  before_create :add_minimal_xml

  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :job_id, :presence => true
  validates :filename, :uniqueness => true


  def path
    "#{location}/#{filename}"
  end

  def completed_destination
    completed_directory = "_completed"
    puts self.path
    subdirectory = self.path.split('/').drop(1)
    puts subdirectory
    "#{MENU_CONFIG['images_dir']}/#{completed_directory}/#{subdirectory}"
  end

  def valid_vra?
    true if validate_vra.empty?
  end

  def validate_vra
    doc = Nokogiri::XML(self.image_xml)

    invalid = []
    XSD.validate(doc).each do |error|
      invalid << "Validation error: #{error.message}"
    end

    invalid.each do |error|
      next if error =~ /is not a valid value of the list type 'xs:IDREFS'/
      next if error =~ /is not a valid value of the atomic type 'xs:IDREF'/
      #raise StandardError
    end
    invalid
  end


  private

    def add_minimal_xml
      self.image_xml = File.read( "#{Rails.root}/app/assets/xml/vra_minimal.xml" ) if self.image_xml.nil?
    end

end
