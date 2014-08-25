class Image < ActiveRecord::Base
  # for grabbing remote vra schema from loc
  require 'open-uri'

  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ], :medium => ["1000x1000", :jpg] }

  before_create :add_minimal_xml

  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :job_id, :presence => true
  validates :filename, :uniqueness => true

  VRA_SCHEMA = open("http://www.loc.gov/standards/vracore/vra-strict.xsd").read

  def path
    "#{location}/#{filename}"
  end

  def valid_vra?
    xsd = Nokogiri::XML::Schema(VRA_SCHEMA)
    doc = Nokogiri::XML(self.image_xml)

    xsd.validate(doc).each do |error|
      return false
    end

    return true
  end


  def validate_vra
    xsd = Nokogiri::XML::Schema(VRA_SCHEMA)
    doc = Nokogiri::XML(self.image_xml)

    invalid = []
    xsd.validate(doc).each do |error|
      invalid << "Validation error: #{error.message}"
    end

    if invalid
      return invalid
    end
  end


  private

    def add_minimal_xml
      self.image_xml = File.read( "#{Rails.root}/app/assets/xml/vra_minimal.xml" ) if self.image_xml.nil?
    end

end
