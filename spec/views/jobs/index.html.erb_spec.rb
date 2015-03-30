require 'rails_helper'

describe 'jobs/index.html.erb', :type => :view do
  it 'shows how many images are in each job'  do
    assign(:jobs, [stub_model(Job) {|job| job.job_id = "1111"}])
    stub_model(Image) {|image| image.job_id = "1111"}
    stub_model(Image) {|image| image.job_id = "1111"}

    render :template => 'jobs/index.html.erb'


    expect(rendered).to have_content "Job IDs 1111 (2)"
  end
end