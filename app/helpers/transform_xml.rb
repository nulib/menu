module TransformXML
  def self.add_display_elements( xml )
    doc = Nokogiri::XML.parse( xml )
    sets = doc.xpath( "//*" ).children[ 1 ].xpath( "./*" )
    sets.each do |node|
      next unless node.element?
      next if node.name == 'dateSet'
      next if node.name == 'subjectSet'
      next if node.name == 'locationSet'
      display = Nokogiri::XML::Node.new 'vra:display', doc
      all_text_nodes = node.xpath( ".//text()" ).to_a
      all_text_nodes.delete_if { |el| el.blank? }
      if node.name == 'agentSet'
        agents = node.children.select { | child | child.name == "agent" }
        joined_agents = agents.collect do | agent |
          [agent.children.to_a.delete_if { |child| child.blank? }.join(", ")]
        end
        display.content = joined_agents.join(" ; ")
      else
        display.content = all_text_nodes.join( " ; " )
      end
      node.children.first.add_previous_sibling( display )
    end

    add_location_set_display( doc )

    doc.to_xml
  end

  def self.get_accession_nbr( xml )
    doc = Nokogiri::XML.parse( xml )
    doc.xpath("//vra:refid[@source='Accession']").text
  end

  private

  def self.add_location_set_display( nokogiri_doc )
    display = Nokogiri::XML::Node.new 'vra:display', nokogiri_doc
    locations = nokogiri_doc.xpath("//vra:locationSet/*").children
    location_set_display = []

    # loop through locationSet child elements and prepend certain cases with source attribute
    locations.each do |child|
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
  end

end

