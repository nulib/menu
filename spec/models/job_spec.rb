require 'rails_helper'

describe Job do
  it 'has a Job ID' do
    job = create( :job, job_id: 999 )

    expect( job.job_id ).to eql( 999 )
  end

  it 'has_many images' do
    job = create(:job_with_images)

    expect( job.images.count ).to eql( 2 )
  end

  it 'orders images by filename' do
    job = create(:job)
    image1 = job.images.create( filename: "002.tif" )
    image2 = job.images.create( filename: "001.tif" )

    expect( job.images.to_a ).to eql( [image2, image1] )
  end
end
