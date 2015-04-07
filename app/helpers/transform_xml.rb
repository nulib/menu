module TransformXML
  def self.add_display_elements( xml )
    doc = Nokogiri::XML.parse( xml )
    sets = doc.xpath( "//*" ).children[ 1 ].xpath( "./*" )
    sets.each do |node|
      next unless node.element?
      next if node.name == 'dateSet'
      next if node.name == 'subjectSet'
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
    doc.to_xml
  end
end

