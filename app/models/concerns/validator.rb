 
module Validator

 def find_required_child(node, child_sought)
    generalNode = node.children.select { | child | child.name == child_sought[:generalNode] }
    specificNode = generalNode[0].children.select { | child | child.name == child_sought[:specificNode] }
    if specificNode.blank? or specificNode[0].children.empty?
      error = "#{child_sought[:errorMsgName]} is required"
    end

    error unless error.nil?
  end
    
  def validate_required_fields(nokogiri_doc)
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

end