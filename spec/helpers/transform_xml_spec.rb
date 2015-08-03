require 'rails_helper'
require 'transform_xml'


describe TransformXML, :type => :helper do

  describe "#prepare_vra_xml" do
    it "returns VRA xml that is ready to be published" do
      xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image>\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:agent>\n                <vra:name type=\"corporate\" vocab=\"lcnaf\">Northern Nigeria (Nigeria). Public Enlightenment Division</vra:name>\n                <vra:attribution/>\n                <vra:role vocab=\"RDA\"/>\n            </vra:agent>\n        </vra:agentSet>\n        <!--Cultural Context-->\n        <vra:culturalContextSet>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>1960</vra:earliestDate>\n                <vra:latestDate>1969</vra:latestDate>\n            </vra:date>\n        </vra:dateSet>\n        <!--Description-->\n        <vra:descriptionSet>\n            <vra:notes>\"P.3. S.W.H.\" ; Drawing of a man and a woman seated on a round mat or rug, with a toddler and a baby between them. The man and the toddler hold a fire engine together and the man has his hand on the child's back. The baby holds a ball in one hand and looks up at the woman, who holds up a piece of weaving in one hand and a piece of yarn or thread in the other, and has a spool in her lap. A basket of spools is on the mat between the woman and the baby. ; Language(s): Hausa</vra:notes>\n            <vra:description>\"P.3. S.W.H.\"</vra:description>\n            <vra:description>Drawing of a man and a woman seated on a round mat or rug, with a toddler and a baby between them. The man and the toddler hold a fire engine together and the man has his hand on the child's back. The baby holds a ball in one hand and looks up at the woman, who holds up a piece of weaving in one hand and a piece of yarn or thread in the other, and has a spool in her lap. A basket of spools is on the mat between the woman and the baby.</vra:description>\n            <vra:description>In Hausa.</vra:description>\n        </vra:descriptionSet>\n        <!--Inscription-->\n        <vra:inscriptionSet>\n            <vra:inscription>\n                <vra:text/>\n            </vra:inscription>\n        </vra:inscriptionSet>\n        <!--Location-->\n        <vra:locationSet>\n            <vra:location type=\"creation\">\n                <vra:name type=\"geographic\">Kaduna, Nigeria</vra:name>\n            </vra:location>\n            <vra:location type=\"repository\">\n                <vra:name type=\"geographic\">Posters from the Herskovits Library</vra:name>\n            </vra:location>\n            <vra:location source=\"MARC 590\">\n                <vra:refid type=\"shelfList\">Object no. 689.</vra:refid>\n            </vra:location>\n            <vra:location>\n                <vra:refid source=\"DIL\"></vra:refid>\n            </vra:location>\n        </vra:locationSet>\n        <!--Materials-->\n        <vra:materialSet>\n            <vra:material>1 poster :</vra:material>\n        </vra:materialSet>\n        <!--Measurements-->\n        <vra:measurementsSet>\n            <vra:measurements>43 x 29 cm</vra:measurements>\n        </vra:measurementsSet>\n        <!--Relation-->\n        <vra:relationSet>\n            <vra:relation pref=\"true\" type=\"imageOf\"/>\n        </vra:relationSet>\n        <!--Rights-->\n        <vra:rightsSet>\n            <vra:rights type=\"undetermined\">\n                <vra:rightsHolder>Undetermined</vra:rightsHolder>\n                <vra:text>The images on this web site, from posters in the collections of the Melville J. Herskovits Library of African Studies of Northwestern University, are provided for use by its students, faculty and staff, and by other researchers visiting this site, for research consultation and scholarly purposes only.  Further distribution and/or any commercial use of the images from this site is not permitted.</vra:text>\n            </vra:rights>\n        </vra:rightsSet>\n        <!--Style Period-->\n        <vra:stylePeriodSet>\n            <vra:stylePeriod/>\n        </vra:stylePeriodSet>\n        <!--Subjects-->\n        <vra:subjectSet>\n            <vra:subject>\n                <vra:term type=\"geographicPlace\" vocab=\"lcnaf\">Nigeria</vra:term>\n            </vra:subject>\n            <vra:subject>\n                <vra:term type=\"descriptiveTopic\" vocab=\"lcsh\">Social values</vra:term>\n            </vra:subject>\n        </vra:subjectSet>\n        <!--Technique-->\n        <vra:techniqueSet>\n            <vra:technique/>\n        </vra:techniqueSet>\n        <!--Textref-->\n        <vra:textrefSet>\n            <vra:textref/>\n        </vra:textrefSet>\n        <!-- Titles -->\n        <vra:titleSet>\n            <vra:title pref=\"true\">'Kina so, ina so,' dankon aure ne : in babu soyayya aure ba ya karko</vra:title>\n        </vra:titleSet>\n        <!--Work Type-->\n        <vra:worktypeSet>\n            <vra:worktype>Prints</vra:worktype>\n        </vra:worktypeSet>\n    </vra:image>\n</vra:vra>"
      filename = "123_1234567.tif"

      xml_ready_to_publish = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image>\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:display>Northern Nigeria (Nigeria). Public Enlightenment Division</vra:display>\n            <vra:agent>\n                <vra:name type=\"corporate\" vocab=\"lcnaf\">Northern Nigeria (Nigeria). Public Enlightenment Division</vra:name>\n                <vra:attribution/>\n                <vra:role vocab=\"RDA\"/>\n            </vra:agent>\n        </vra:agentSet>\n        <!--Cultural Context-->\n        <vra:culturalContextSet>\n            <vra:display/>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>1960</vra:earliestDate>\n                <vra:latestDate>1969</vra:latestDate>\n            </vra:date>\n        </vra:dateSet>\n        <!--Description-->\n        <vra:descriptionSet>\n            <vra:display>\"P.3. S.W.H.\" ; Drawing of a man and a woman seated on a round mat or rug, with a toddler and a baby between them. The man and the toddler hold a fire engine together and the man has his hand on the child's back. The baby holds a ball in one hand and looks up at the woman, who holds up a piece of weaving in one hand and a piece of yarn or thread in the other, and has a spool in her lap. A basket of spools is on the mat between the woman and the baby. ; Language(s): Hausa</vra:display>\n            <vra:notes>\"P.3. S.W.H.\" ; Drawing of a man and a woman seated on a round mat or rug, with a toddler and a baby between them. The man and the toddler hold a fire engine together and the man has his hand on the child's back. The baby holds a ball in one hand and looks up at the woman, who holds up a piece of weaving in one hand and a piece of yarn or thread in the other, and has a spool in her lap. A basket of spools is on the mat between the woman and the baby. ; Language(s): Hausa</vra:notes>\n            <vra:description>\"P.3. S.W.H.\"</vra:description>\n            <vra:description>Drawing of a man and a woman seated on a round mat or rug, with a toddler and a baby between them. The man and the toddler hold a fire engine together and the man has his hand on the child's back. The baby holds a ball in one hand and looks up at the woman, who holds up a piece of weaving in one hand and a piece of yarn or thread in the other, and has a spool in her lap. A basket of spools is on the mat between the woman and the baby.</vra:description>\n            <vra:description>In Hausa.</vra:description>\n        </vra:descriptionSet>\n        <!--Inscription-->\n        <vra:inscriptionSet>\n            <vra:display/>\n            <vra:inscription>\n                <vra:text/>\n            </vra:inscription>\n        </vra:inscriptionSet>\n        <!--Location-->\n        <vra:locationSet>\n            <vra:display>Kaduna, Nigeria ; Posters from the Herskovits Library ; Object no. 689. ; Accession:1234567</vra:display>\n            <vra:location type=\"creation\">\n                <vra:name type=\"geographic\">Kaduna, Nigeria</vra:name>\n            </vra:location>\n            <vra:location type=\"repository\">\n                <vra:name type=\"geographic\">Posters from the Herskovits Library</vra:name>\n            </vra:location>\n            <vra:location source=\"MARC 590\">\n                <vra:refid type=\"shelfList\">Object no. 689.</vra:refid>\n            </vra:location>\n            <vra:location>\n                <vra:refid source=\"DIL\"></vra:refid><vra:refid source=\"Accession\">1234567</vra:refid>\n            </vra:location>\n        </vra:locationSet>\n        <!--Materials-->\n        <vra:materialSet>\n            <vra:display>1 poster</vra:display>\n            <vra:material>1 poster :</vra:material>\n        </vra:materialSet>\n        <!--Measurements-->\n        <vra:measurementsSet>\n            <vra:display>43 x 29 cm</vra:display>\n            <vra:measurements>43 x 29 cm</vra:measurements>\n        </vra:measurementsSet>\n        <!--Relation-->\n        <vra:relationSet>\n            <vra:display/>\n        <vra:relation pref=\"true\" type=\"imageOf\"/>\n        </vra:relationSet>\n        <!--Rights-->\n        <vra:rightsSet>\n            <vra:display>The images on this web site, from posters in the collections of the Melville J. Herskovits Library of African Studies of Northwestern University, are provided for use by its students, faculty and staff, and by other researchers visiting this site, for research consultation and scholarly purposes only.  Further distribution and/or any commercial use of the images from this site is not permitted.</vra:display>\n            <vra:rights type=\"undetermined\">\n                <vra:rightsHolder>Undetermined</vra:rightsHolder>\n                <vra:text>The images on this web site, from posters in the collections of the Melville J. Herskovits Library of African Studies of Northwestern University, are provided for use by its students, faculty and staff, and by other researchers visiting this site, for research consultation and scholarly purposes only.  Further distribution and/or any commercial use of the images from this site is not permitted.</vra:text>\n            </vra:rights>\n        </vra:rightsSet>\n        <!--Style Period-->\n        <vra:stylePeriodSet>\n            <vra:display/>\n            <vra:stylePeriod/>\n        </vra:stylePeriodSet>\n        <!--Subjects-->\n        <vra:subjectSet>\n            <vra:subject>\n                <vra:term type=\"geographicPlace\" vocab=\"lcnaf\">Nigeria</vra:term>\n            </vra:subject>\n            <vra:subject>\n                <vra:term type=\"descriptiveTopic\" vocab=\"lcsh\">Social values</vra:term>\n            </vra:subject>\n        </vra:subjectSet>\n        <!--Technique-->\n        <vra:techniqueSet>\n            <vra:display/>\n            <vra:technique/>\n        </vra:techniqueSet>\n        <!--Textref-->\n        <vra:textrefSet>\n            <vra:display/>\n            <vra:textref/>\n        </vra:textrefSet>\n        <!-- Titles -->\n        <vra:titleSet>\n            <vra:display>'Kina so, ina so,' dankon aure ne : in babu soyayya aure ba ya karko</vra:display>\n            <vra:title pref=\"true\">'Kina so, ina so,' dankon aure ne : in babu soyayya aure ba ya karko</vra:title>\n        </vra:titleSet>\n        <!--Work Type-->\n        <vra:worktypeSet>\n            <vra:display>Prints</vra:display>\n            <vra:worktype>Prints</vra:worktype>\n        </vra:worktypeSet>\n    </vra:image>\n<vra:work/></vra:vra>"

      expect(Nokogiri::XML(TransformXML.prepare_vra_xml(xml, filename))).to be_equivalent_to(Nokogiri::XML(xml_ready_to_publish)).ignoring_content_of(["vra|agentSet", "vra|descriptionSet", "vra|materialSet", "vra|measurementsSet", "vra|rightsSet"])
    end
  end

  describe "#add_display_elements" do
    it "adds agentSet displays with commas between agents and semi-colons between agentSets" do

      xml_with_agentSet_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image>\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:agent>\n                <vra:name type=\"personal\" vocab=\"lcnaf\">agent Uno</vra:name>\n                <vra:attribution>att uno</vra:attribution>\n                <vra:role vocab=\"RDA\">role uno</vra:role>\n            </vra:agent>\n            <vra:agent>\n                <vra:name>Agent duo</vra:name>\n                <vra:attribution>att duo</vra:attribution>\n                <vra:role>role duo</vra:role>\n            </vra:agent>\n        </vra:agentSet>\n        <!--Cultural Context-->\n        <vra:culturalContextSet>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display/>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>present</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet></vra:image>\n    </vra:vra>"
      xml_with_agentSet = Nokogiri::XML(xml_with_agentSet_string)

      xml_with_agentSet_display = "<vra:agentSet><vra:display>agent Uno, att uno, role uno ; Agent duo, att duo, role duo</vra:display>"

      expect(TransformXML.add_display_elements(xml_with_agentSet).to_xml).to include(xml_with_agentSet_display)
    end


    it "only adds commas between existing agent elements" do
      xml_with_agentSet_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image>\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:agent>\n                <vra:name type=\"personal\" vocab=\"lcnaf\">agent Uno</vra:name>\n                <vra:attribution></vra:attribution>\n                <vra:role vocab=\"RDA\"></vra:role>\n            </vra:agent>\n            <vra:agent>\n                <vra:name>Agent duo</vra:name>\n                <vra:attribution></vra:attribution>\n                <vra:role>role duo</vra:role>\n            </vra:agent>\n
      <vra:agent>\n                <vra:name type=\"personal\" vocab=\"lcnaf\">agent Dre</vra:name>\n                <vra:attribution>attribution dre</vra:attribution>\n                <vra:role vocab=\"RDA\">role dre</vra:role>\n            </vra:agent>\n </vra:agentSet>\n        <!--Cultural Context-->\n        <vra:culturalContextSet>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display/>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>present</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet></vra:image>\n    </vra:vra>"

      xml_with_agentSet = Nokogiri::XML(xml_with_agentSet_string)

      TransformXML.add_display_elements(xml_with_agentSet).to_xml
      agent_display_content = xml_with_agentSet.xpath("//vra:agentSet//vra:display")

      expect("#{agent_display_content}").to eql("<vra:display>agent Uno ; Agent duo, role duo ; agent Dre, attribution dre, role dre</vra:display>")
    end

    it "doesn't add the notes element to the descriptionSet display element" do
      xml_with_description_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image>\n<!--Cultural Context-->\n        <vra:culturalContextSet>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display/>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>present</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet>
        <!--Description-->
        <vra:descriptionSet>
            <vra:notes>I am description notes</vra:notes>
            <vra:description>Okay I am first description</vra:description>
            <vra:description>And I am second one</vra:description>
        </vra:descriptionSet>
        </vra:image>\n
        </vra:vra>"

      xml_with_description = Nokogiri::XML(xml_with_description_string)
      TransformXML.add_display_elements(xml_with_description).to_xml
      description_display_content = xml_with_description.xpath("//vra:descriptionSet//vra:display")

      expect("#{description_display_content}").to eql("<vra:display>Okay I am first description ; And I am second one</vra:display>")
    end

    it "doesn't add the rightsHolder element to the rightsSet display element" do
      xml_with_rights_string =  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image>\n<!--Rights-->
        <vra:rightsSet>
            <vra:rights>
                <vra:rightsHolder>first holder</vra:rightsHolder>
                <vra:text>first text</vra:text>
            </vra:rights>
            <vra:rights>
                <vra:rightsHolder>second holder</vra:rightsHolder>
                <vra:text>second text</vra:text>
            </vra:rights>
        </vra:rightsSet>
        </vra:image>\n
        </vra:vra>"

        xml_with_rights = Nokogiri::XML(xml_with_rights_string)
        TransformXML.add_display_elements(xml_with_rights)
        rights_display_content = xml_with_rights.xpath("//vra:rightsSet//vra:display")

        expect("#{rights_display_content}").to eql("<vra:display>first text ; second text</vra:display>")

    end

    it "adds locationSet display with source attributes prepended with a colon" do

      xml_with_locationSet_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image><!--Location--><vra:locationSet><vra:location type=\"creation\"><vra:name type=\"geographic\">London</vra:name></vra:location><vra:location type=\"repository\"><vra:name type=\"geographic\">Posters from the Herskovits Library</vra:name></vra:location><vra:location source=\"MARC 590\"><vra:refid type=\"shelfList\">Object no. SA.5.</vra:refid></vra:location><vra:location><vra:refid source=\"DIL\"/><vra:refid source=\"Voyager\">1234567</vra:refid><vra:refid source=\"Accession\">7654321</vra:refid></vra:location></vra:locationSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display/>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>present</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet></vra:image>\n    </vra:vra>"
      xml_with_locationSet = Nokogiri::XML(xml_with_locationSet_string)

      xml_with_locationSet_display = "<vra:locationSet><vra:display>London ; Posters from the Herskovits Library ; Object no. SA.5. ; Voyager:1234567 ; Accession:7654321</vra:display>"

      expect(TransformXML.add_display_elements(xml_with_locationSet).to_xml).to include(xml_with_locationSet_display)
    end
  end

  describe "#add_display_elements" do
    it "adds the accession number from the filename to a refid['source'='Accession'] node" do
      xml_without_accession_number_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image><!--Location--><vra:locationSet><vra:location><vra:refid source=\"DIL\"/></vra:location></vra:locationSet></vra:image>\n    </vra:vra>"
      xml_without_accession_number = Nokogiri::XML(xml_without_accession_number_string)

      filename = "001_test.tif"
      xml_with_accession_number = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image><!--Location--><vra:locationSet><vra:location><vra:refid source=\"DIL\"/><vra:refid source=\"Accession\">test</vra:refid></vra:location></vra:locationSet></vra:image>\n    </vra:vra>"

      expect(TransformXML.add_refid_accession_nbr(xml_without_accession_number, filename).to_xml).to be_equivalent_to(xml_with_accession_number)
    end
  end

  describe "#get_accession_nbr" do
    it "extracts the accession number from the vra_xml" do
      xml_with_accession = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<vra:vra\n    xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n    xmlns:fn=\"http://www.w3.org/2005/xpath-functions\"\n    xmlns:vra=\"http://www.vraweb.org/vracore4.htm\"\n    xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xsi:schemaLocation=\"http://www.vraweb.org/vracore4.htm http://www.loc.gov/standards/vracore/vra-strict.xsd\">\n    <vra:image>\n        <!--Agents-->\n        <vra:agentSet>\n            <vra:agent>\n                <vra:name type=\"personal\" vocab=\"lcnaf\"/>\n                <vra:attribution/>\n                <vra:role vocab=\"RDA\"/>\n            </vra:agent>\n        </vra:agentSet>\n        <!--Cultural Context-->\n        <vra:culturalContextSet>\n            <vra:culturalContext/>\n        </vra:culturalContextSet>\n        <!--Dates-->\n        <vra:dateSet>\n            <vra:display/>\n            <vra:date type=\"creation\">\n                <vra:earliestDate>2015</vra:earliestDate>\n            </vra:date>\n        </vra:dateSet>\n        <!--Description-->\n        <vra:descriptionSet>\n            <vra:description/>\n        </vra:descriptionSet>\n        <!--Inscription-->\n        <vra:inscriptionSet>\n            <vra:inscription>\n                <vra:text/>\n            </vra:inscription>\n        </vra:inscriptionSet>\n        <!--Location-->\n        <vra:locationSet>\n            <vra:location type=\"creation\">\n                <vra:name type=\"geographic\"/>\n            </vra:location>\n            <vra:location type=\"repository\">\n                <vra:name type=\"geographic\"/>\n            </vra:location>\n            <vra:location>\n                <vra:refid source=\"DIL\"/>\n                <vra:refid source=\"Accession\">1234</vra:refid>\n            </vra:location>\n        </vra:locationSet>\n        <!--Materials-->\n        <vra:materialSet>\n            <vra:material/>\n        </vra:materialSet>\n        <!--Measurements-->\n        <vra:measurementsSet>\n            <vra:measurements/>\n        </vra:measurementsSet>\n        <!--Relation-->\n        <vra:relationSet>\n            <vra:relation pref=\"true\" type=\"imageOf\" relids=\"\"/>\n        </vra:relationSet>\n        <!--Rights-->\n        <vra:rightsSet>\n            <vra:rights>\n                <vra:rightsHolder/>\n                <vra:text/>\n            </vra:rights>\n        </vra:rightsSet>\n        <!-- Source -->\n        <vra:sourceSet>\n            <vra:source/>\n        </vra:sourceSet>\n        <!--Style Period-->\n        <vra:stylePeriodSet>\n            <vra:stylePeriod/>\n        </vra:stylePeriodSet>\n        <!--Subjects-->\n        <vra:subjectSet>\n            <vra:display/>\n            <vra:subject>\n                <vra:term type=\"geographicPlace\" vocab=\"lcnaf\"/>\n            </vra:subject>\n            <vra:subject>\n                <vra:term type=\"personalName\" vocab=\"lcnaf\"/>\n            </vra:subject>\n            <vra:subject>\n                <vra:term type=\"personalName\" vocab=\"lcnaf\"/>\n            </vra:subject>\n            <vra:subject>\n                <vra:term type=\"otherTopic\"/>\n            </vra:subject>\n            <vra:subject>\n                <vra:term type=\"descriptiveTopic\" vocab=\"lcsh\"/>\n            </vra:subject>\n        </vra:subjectSet>\n        <!--Technique-->\n        <vra:techniqueSet>\n            <vra:technique/>\n        </vra:techniqueSet>\n        <!--Textref-->\n        <vra:textrefSet>\n            <vra:textref/>\n        </vra:textrefSet>\n        <!-- Titles -->\n        <vra:titleSet>\n            <vra:title pref=\"true\">Testing dupe check</vra:title>\n        </vra:titleSet>\n        <!--Work Type-->\n        <vra:worktypeSet>\n            <vra:worktype/>\n        </vra:worktypeSet>\n    </vra:image>\n    <vra:work/>\n</vra:vra>"
      expect(TransformXML.get_accession_nbr(xml_with_accession)).to eql("1234")
    end
  end
end