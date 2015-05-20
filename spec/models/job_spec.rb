require 'rails_helper'

describe Job do
  it 'has a Job ID' do
    job = create( :job, job_id: 999 )

    expect( job.job_id ).to eql( 999 )
  end

  it 'has_many new_records' do
    job = create(:job_with_new_records)

    expect( job.new_records.count ).to eql( 2 )
  end

  it 'orders new_record by filename' do
    job = create(:job)
    new_record1 = job.new_records.create( filename: "002.tif" )
    new_record2 = job.new_records.create( filename: "001.tif" )

    expect( job.new_records.to_a ).to eql( [new_record2, new_record1] )
  end
end
