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

    def get_pid_from_response( response )
      response_xml_doc = Nokogiri::XML( response )
      response_xml_doc.at_xpath( '//pid' ).text
    end

    def add_relation_to_image( xml )
      image_xml_doc = Nokogiri::XML( xml )
      image_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'type' ] = 'imageOf'
      image_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'relids' ] = work_pid
      image_xml_doc.to_xml.strip
    end

    def add_refid_to_image ( xml )
      image_xml_doc = Nokogiri::XML( xml )
      image_xml_doc.at_xpath( '//vra:image', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'refid' ] = image_pid
      self.image_xml = image_xml_doc.to_xml.strip
    end
end
