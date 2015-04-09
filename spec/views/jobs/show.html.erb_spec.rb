require 'rails_helper'

describe 'jobs/show.html.erb', :type => :view do

  it 'contains links that say Delete instead of Destroy' do
    image1 = create(:image)
    image2 = create(:image)
    @images = [image1, image2]

    render

    expect(rendered).to have_link 'Delete'
  end

it "displays the user-given job_id, not the rails job_id in image data" do
    image1 = create(:image)
    image2 = create(:image)
    @images = [image1, image2]

  render
  expect(rendered).to have_content  image1.job.job_id
end

end

