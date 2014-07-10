class Image < ActiveRecord::Base
  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ], :medium => ["1000x1000", :jpg] }

  before_create :add_minimal_xml
  
  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :job_id, :presence => true
  validates :filename, :uniqueness => true

  private

    def add_minimal_xml
      self.image_xml = File.read( "#{Rails.root}/app/assets/xml/vra_minimal.xml" ) if self.image_xml.nil?
    end

    def transform_image_into_work( xml )
      work_xml_doc = Nokogiri::XML( xml )
      work_xml_doc.at_xpath( '//vra:image', vra:  'http://www.vraweb.org/vracore4.htm' ).name = "work"
      work_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'type' ] = 'imageIs'
      work_xml_doc.to_xml.strip
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

    def add_refid_and_relation_to_work( xml )
      work_xml_doc = Nokogiri::XML( xml )
      work_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'type' ] = 'imageIs'
      work_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'relids' ] = image_pid
      work_xml_doc.at_xpath( '//vra:work', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'refid' ] = work_pid
      work_xml_doc.to_xml.strip
    end

    def add_refid_to_image ( xml )
      image_xml_doc = Nokogiri::XML( xml )
      image_xml_doc.at_xpath( '//vra:image', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'refid' ] = image_pid
      self.image_xml = image_xml_doc.to_xml.strip
    end
end
