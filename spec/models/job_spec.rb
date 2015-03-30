require 'rails_helper'

describe Job do
  it 'has a Job ID' do
    job = Job.create( job_id: 123 )

    expect( job.job_id ).to eql( 123 )
  end

  it 'has_many images' do
    job = Job.create( job_id: 123 )
    image = job.images.create

    expect( job.images.count ).to eql( 1 )
  end

  it 'orders images by filename' do
    job = Job.create( job_id: 123 )
    image1 = job.images.create(filename: "002.tif")
    image2 = job.images.create(filename: "001.tif")

    expect( job.images.to_a ).to eql( [image2, image1] )
  end
end
