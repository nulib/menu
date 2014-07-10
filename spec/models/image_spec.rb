require 'rails_helper'

describe Image do
  it "has a non-empty xml attribute" do
    @image = Image.create( job_id: 'test' )
    expect( @image.image_xml ).to be_truthy
  end

  context "a new image" do
    it "has the default VRA XML in the xml attribute" do
      @image = Image.create( job_id: 'test' )
      default_xml = File.read( 'app/assets/xml/vra_minimal.xml' )
      expect( @image.image_xml ).to eql( default_xml )
    end
  end

  context "transforming image for API calls" do
    
    it "transforms the vra:image record into a vra:work record" do
      @image = Image.create( job_id: 'test', image_xml: '<?xml version="1.0"?>
<?xml-stylesheet type="text/css" href="vraCore.css" ?>
<vra:vra xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
 <vra:image>
   <vra:relationSet>
     <vra:relation pref="true" type="imageIs"/>
   </vra:relationSet>
 </vra:image>
</vra:vra>' )
      work_xml = @image.send( :transform_image_into_work, @image.image_xml )
      expect( work_xml ).to eql('<?xml version="1.0"?>
<?xml-stylesheet type="text/css" href="vraCore.css" ?>
<vra:vra xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
 <vra:work>
   <vra:relationSet>
     <vra:relation pref="true" type="imageIs"/>
   </vra:relationSet>
 </vra:work>
</vra:vra>')
    end

    it "gets the pid from the response for the work record" do
      @image = Image.create( job_id: 'test' )
      resp = '<response><returnCode>Save successful</returnCode><pid>inu:test-536679ef-f55a-455f-a638-2c3887c44e19</pid></response>'
      pid = @image.send( :get_pid_from_response, resp )
      expect( pid ).to eql('inu:test-536679ef-f55a-455f-a638-2c3887c44e19')
    end

    it "adds the relid of the work to the image_xml relation element and sets the type to 'imageOf'" do
      @image = Image.create( job_id: 'test', image_xml: '<?xml version="1.0"?>
<?xml-stylesheet type="text/css" href="vraCore.css" ?>
<vra:vra xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
 <vra:image>
   <vra:relationSet>
     <vra:relation />
   </vra:relationSet>
 </vra:image>
</vra:vra>' )
      @image.work_pid = 'inu:test-work-pid-536679ef-f55a-455f-a638-2c3887c44e19'
      image_xml = @image.send( :add_relation_to_image, @image.image_xml )
      expect( image_xml ).to eql('<?xml version="1.0"?>
<?xml-stylesheet type="text/css" href="vraCore.css" ?>
<vra:vra xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
 <vra:image>
   <vra:relationSet>
     <vra:relation type="imageOf" relids="inu:test-work-pid-536679ef-f55a-455f-a638-2c3887c44e19"/>
   </vra:relationSet>
 </vra:image>
</vra:vra>')
    end

    it "adds the relid of the image to the work_xml relation element, sets the type to 'imageIs', and adds the refid of the work" do
      @image = Image.create( job_id: 'test', work_xml: '<?xml version="1.0"?>
<?xml-stylesheet type="text/css" href="vraCore.css" ?>
<vra:vra xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
 <vra:work>
   <vra:relationSet>
     <vra:relation />
   </vra:relationSet>
 </vra:work>
</vra:vra>' )
      @image.work_pid = 'inu:test-work-a6e58884-cf1c-4fac-8273-183fee8e9615'
      @image.image_pid = 'inu:test-image-pid-536679ef-f55a-455f-a638-2c3887c44e19'
      image_xml = @image.send( :add_refid_and_relation_to_work, @image.work_xml )
      expect( image_xml ).to eql('<?xml version="1.0"?>
<?xml-stylesheet type="text/css" href="vraCore.css" ?>
<vra:vra xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
 <vra:work refid="inu:test-work-a6e58884-cf1c-4fac-8273-183fee8e9615">
   <vra:relationSet>
     <vra:relation type="imageIs" relids="inu:test-image-pid-536679ef-f55a-455f-a638-2c3887c44e19"/>
   </vra:relationSet>
 </vra:work>
</vra:vra>')
    end

    it "adds the refid to the image record" do
      @image = Image.create( job_id: 'test', image_xml: '<?xml version="1.0"?>
<?xml-stylesheet type="text/css" href="vraCore.css" ?>
<vra:vra xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
 <vra:image>
 </vra:image>
</vra:vra>' )
      @image.image_pid = 'inu:test-image-a6e58884-cf1c-4fac-8273-183fee8e9615'
      image_xml = @image.send( :add_refid_to_image, @image.image_xml )
      expect( image_xml ).to eql('<?xml version="1.0"?>
<?xml-stylesheet type="text/css" href="vraCore.css" ?>
<vra:vra xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
 <vra:image refid="inu:test-image-a6e58884-cf1c-4fac-8273-183fee8e9615">
 </vra:image>
</vra:vra>')
    end
  end
end
