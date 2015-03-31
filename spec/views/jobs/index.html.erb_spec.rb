require 'rails_helper'
require 'spec_helper'

describe 'jobs/index.html.erb', :type => :view do
  it 'shows how many images are in each job'  do

    job1 = create(:job_with_images)
    job2 = create(:job_with_images)
    @jobs = [job1, job2]

    render :template => 'jobs/index.html.erb'

    expect(rendered).to have_content "#{job1.job_id} (#{job1.images.size})"
  end
end