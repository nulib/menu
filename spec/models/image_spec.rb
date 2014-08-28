require 'rails_helper'

WebMock.allow_net_connect!

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
end

WebMock.disable_net_connect!
