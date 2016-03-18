module TransformXML

  def self.prepare_vra_xml( xml, filename )
    nokogiri_doc = Nokogiri::XML.parse( xml )

    add_refid_accession_nbr( nokogiri_doc, filename )
    add_display_elements( nokogiri_doc )
    add_empty_work_element( nokogiri_doc )

    return nokogiri_doc.to_xml
  end

  def self.add_display_elements( nokogiri_doc )
    sets = nokogiri_doc.xpath( "//*" ).children[ 1 ].xpath( "./*" )
    sets.each do |node|
      next unless node.element?
      next if node.name == 'dateSet'
      next if node.name == 'subjectSet'
      next if node.name == 'locationSet'

      display = Nokogiri::XML::Node.new 'vra:display', nokogiri_doc
      all_text_nodes = node.xpath( ".//text()" ).to_a
      all_text_nodes.delete_if { |el| el.blank? }
      if node.name == 'agentSet'
        display.content = transform_agent_set(node)
      elsif node.name == 'descriptionSet'
        display.content = transform_description_set(node)
      elsif node.name == 'rightsSet'
        display.content = transform_rights_set(node)
      elsif node.name == 'textrefSet'
        display.content = transform_textref_set(node)
      else
        display.content = all_text_nodes.join( " ; " )
      end
      node.children.first.add_previous_sibling( display )
    end

    add_location_set_display( nokogiri_doc )

    nokogiri_doc
  end

  def self.transform_agent_set(node)
    agents = node.children.select {| child | child.name == "agent" }
        joined_agents = agents.collect do | agent |
          agent_children = [agent.children.to_a.delete_if {| child | child.blank? }]
          agent_children[0].delete_if {| child | child.content.blank? }
          agent_children.join(", ")
        end
      joined_agents.join(" ; ")
  end

  def self.transform_description_set(node)
    description_children = node.children.to_a
    description_children.delete_if {| child | child.name == "notes" or child.blank? }
    description_children.join(" ; ")
  end

  def self.transform_textref_set(node)
    textrefs = node.children.select {| child | child.name == "textref" }
        joined_textrefs = textrefs.collect do | textref |
          textref_children = [textref.children.to_a.delete_if {| child | child.blank? }]
          textref_children[0].delete_if {| child | child.content.blank? }
          textref_children.join(", ")
        end
      joined_textrefs.join(" ; ")
  end

  def self.transform_rights_set(node)
    rights_set = node.children.to_a.map do | item |
      if item.name == "rights"
        item.children.to_a.delete_if {|child| child.name == "rightsHolder" or child.blank? }
      end
    end.compact!

   rights_set.join(" ; ")
  end

  def self.add_refid_accession_nbr( nokogiri_doc, filename )
    if nokogiri_doc.xpath("//vra:refid[@source='DIL']").present? && filename.present?
      refid = Nokogiri::XML::Node.new("vra:refid", nokogiri_doc)
      refid['source'] = "Accession"
      refid.content = File.basename( filename.slice( filename.index( '_' ) + 1, filename.length ), ".*" )
      nokogiri_doc.xpath("//vra:refid[@source='DIL']").first.add_next_sibling(refid)
    end
    nokogiri_doc
  end

  def self.get_accession_nbr( xml )
    doc = Nokogiri::XML.parse( xml )
    doc.xpath("//vra:refid[@source='Accession']").text
  end

  def self.add_empty_work_element( nokogiri_doc )
    remove_work_elements( nokogiri_doc )

    work_element = Nokogiri::XML::Node.new('vra:work', nokogiri_doc)
    nokogiri_doc.root.add_child(work_element)

    nokogiri_doc
  end

  private

  def self.add_location_set_display( nokogiri_doc )
    if nokogiri_doc.xpath("//vra:locationSet/*").children.any?
      display = Nokogiri::XML::Node.new 'vra:display', nokogiri_doc
      locations = nokogiri_doc.xpath("//vra:locationSet/*").children
      location_set_display = []

      # loop through locationSet child elements and prepend certain cases with source attribute
      locations.each do |child|
        next unless child.element?
        case
        when child['source'] == 'Voyager'
          location_set_display << "Voyager:#{child.text}"
        when child['source'] == 'Accession'
          location_set_display << "Accession:#{child.text}"
        else
          location_set_display<< child.text
        end
      end
      display.content = location_set_display.delete_if { |el| el.blank? }.join( " ; " )
      nokogiri_doc.xpath("//vra:locationSet").children.first.add_previous_sibling( display )
    else
      nokogiri_doc
    end
  end

  def self.remove_work_elements( nokogiri_doc )
    nokogiri_doc.search('//vra:work').remove if nokogiri_doc.xpath('//vra:work').any?
  end

end
