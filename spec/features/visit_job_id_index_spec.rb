require 'rails_helper'

describe "visiting the home page" do
  it "displays a Job ID header" do
    visit root_path

    expect( page ).to have_content( "Job IDs" )
  end

  it "displays a list of linked Job IDs" do
    job = Job.create( job_id: 123 )

    visit root_path

    expect( page ).to have_css( "li.job_link>a" )
  end
end
