require 'rails_helper'

describe 'jobs/show.html.erb', :type => :view do

  it 'contains links that say Delete instead of Destroy' do
    image1 = create(:image)
    image2 = create(:image)
    @images = [image1, image2]

    render

    expect(rendered).to have_link 'Delete'
  end
end

