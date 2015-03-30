require 'rails_helper'

describe 'jobs/show.html.erb', :type => :view do

  it 'contains links that say Delete instead of Destroy' do
    assign(:images, [stub_model(Image) {|image| image.job_id = "test_id"}])
    render

    expect(rendered).to have_link 'Delete'
  end
end