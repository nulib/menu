 
module Validator

 def find_required_child(node, child_sought)
    generalNode = node.children.select { | child | child.name == child_sought[:generalNode] }
    specificNode = generalNode[0].children.select { | child | child.name == child_sought[:specificNode] }
    if specificNode.blank? or specificNode[0].children.empty?
      error = "#{child_sought[:errorMsgName]} is required"
    end

    error unless error.nil?
  end
    
  def validate_preferred_fields(nokogiri_doc)
    #date, title, agent
    invalid = []
    sets = nokogiri_doc.xpath( "//*" ).children[ 1 ].xpath( "./*" )
    #ok -- title is working but shows up in same div, which is not good, you can miss it.

    # so maybe remove error divs if they're there
    sets.each do |node|
      if node.name == 'dateSet' 
        child_sought = {}
        child_sought[:generalNode] = "date"
        child_sought[:specificNode] = "earliestDate"
        child_sought[:errorMsgName] = "Creation date"

        error = find_required_child(node, child_sought)
        invalid << error unless error.nil?
      end
     
      if node.name == 'agentSet'
        child_sought = {}
        child_sought[:generalNode] = "agent"
        child_sought[:specificNode] = "name"
        child_sought[:errorMsgName] = "Agent Name"

        error = find_required_child(node, child_sought)
        invalid << error unless error.nil?
      end

      if node.name == 'titleSet'
        title = node.children.select { | child | child.name == "title" }
        if title[0].children.empty?
          error = "Title is required"
          invalid << error
        end
      end

    end
    invalid unless invalid.empty? 

  end

  def validate_vra
    doc = Nokogiri::XML(self.image_xml)

    invalid = []
    XSD.validate(doc).each do |error|
      invalid << "Validation error: #{error.message}"
    end
    preferred_fields = validate_preferred_fields(doc)
    invalid << preferred_fields unless preferred_fields.nil?

    invalid.each do |error|
      next if error =~ /is not a valid value of the list type 'xs:IDREFS'/
      next if error =~ /is not a valid value of the atomic type 'xs:IDREF'/
      #raise StandardError
    end

    invalid
  end
end