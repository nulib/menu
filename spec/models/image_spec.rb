require 'rails_helper'

describe Image do
  it "has a non-empty xml attribute" do
    @image = Image.create( job_id: 'test' )
    expect( @image.xml ).to be_truthy
  end
end
