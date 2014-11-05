require 'rails_helper'

describe 'the edit view should have an image with medium dimension style' do

  before :each do
    job = Job.create( job_id: 123 )
    image = job.images.create
    visit root_url
    click_link( '123' )
    first('.image-entry').click_link('Edit')
  end

  it 'has an image' do
    expect(page).to have_css('img')
  end

  it 'is the correct dimension style' do
    expect(page).to have_css('.medium')
  end

end
