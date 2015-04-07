require 'rails_helper'
require 'transform_xml'



describe TransformXML, :type => :helper do
  describe "#add_display_elements" do


    it "adds agentSet displays with commas between agents and semi-colons between agentSets" do

      xml_with_agentSet = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image>\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:agent>\n                <vra:name type=\"personal\" vocab=\"lcnaf\">agent Uno</vra:name>\n                <vra:attribution>att uno</vra:attribution>\n                <vra:role vocab=\"RDA\">role uno</vra:role>\n            </vra:agent>\n            <vra:agent>\n                <vra:name>Agent duo</vra:name>\n                <vra:attribution>att duo</vra:attribution>\n                <vra:role>role duo</vra:role>\n            </vra:agent>\n        </vra:agentSet>\n        <!--Cultural Context-->\n        <vra:culturalContextSet>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display/>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>present</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet></vra:image>\n    </vra:vra>"

      xml_with_agentSet_display = "<vra:agentSet><vra:display>agent Uno, att uno, role uno ; Agent duo, att duo, role duo</vra:display>"

      expect(TransformXML.add_display_elements(xml_with_agentSet)).to include(xml_with_agentSet_display)
    end
  end
end