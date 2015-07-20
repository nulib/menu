require 'rails_helper'

describe "Adds display fields to VRA:image" do
  it "successfully" do
    vra_without_display = Nokogiri::XML(File.read( Rails.root.join( 'spec', 'fixtures', 'vra_no_display.xml' )))
    vra_with_display = File.read( Rails.root.join( 'spec', 'fixtures', 'vra_display_with_content.xml' ))

    vra = TransformXML.add_display_elements( vra_without_display )

    expect( vra.to_xml ).to be_equivalent_to( vra_with_display ).respecting_element_order
  end
end

