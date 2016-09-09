require 'rails_helper'

describe NewRecord do

  it "fails to save without a parent Job" do
    new_record = NewRecord.create

    expect( new_record.errors.messages ).not_to be_empty
  end

  it "saves with a parent Job" do
    job = create(:job_with_new_records)
    new_record = job.new_records.first

    expect( new_record.errors.messages ).to be_empty
  end

  it "has a non-empty xml attribute" do
    job = create(:job_with_new_records)
    new_record = job.new_records.first

    expect( new_record.xml ).to be_truthy
  end


  context "a new_record" do
    it "has the default VRA XML in the xml attribute" do
      job = create(:job_with_new_records)
      new_record = job.new_records.first
      default_xml = Nokogiri::XML(File.read( 'app/assets/xml/vra_minimal.xml' ))

      expect( Nokogiri::XML(new_record.xml) ).to be_equivalent_to( default_xml )
    end

  end
end
