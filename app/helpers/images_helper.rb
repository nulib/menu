module ImagesHelper

  def self.transform_image_into_work( xml )
    work_xml_doc = Nokogiri::XML( xml )
    work_xml_doc.at_xpath( '//vra:image', vra:  'http://www.vraweb.org/vracore4.htm' ).name = "work"
    work_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'type' ] = 'imageIs'
    work_xml_doc.to_xml.strip
  end

  def self.get_pid_from_response( response )
    response_xml_doc = Nokogiri::XML( response )
    response_xml_doc.at_xpath( '//pid' ).text
  end

  def self.add_relation_to_image( xml, work_pid )
    image_xml_doc = Nokogiri::XML( xml )
    image_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'type' ] = 'imageOf'
    image_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'relids' ] = work_pid    
    image_xml_doc.to_xml.strip
  end

  def self.add_refid_and_relation_to_work( xml, image_pid, work_pid )
    work_xml_doc = Nokogiri::XML( xml )
    work_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'type' ] = 'imageIs'
    work_xml_doc.at_xpath( '//vra:relationSet/vra:relation', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'relids' ] = image_pid
    work_xml_doc.at_xpath( '//vra:work', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'refid' ] = work_pid
    work_xml_doc.to_xml.strip
  end

  def self.add_refid_to_image ( xml, image_pid )
    image_xml_doc = Nokogiri::XML( xml )
    image_xml_doc.at_xpath( '//vra:image', vra:  'http://www.vraweb.org/vracore4.htm' )[ 'refid' ] = image_pid
    xml = image_xml_doc.to_xml.strip
  end

end