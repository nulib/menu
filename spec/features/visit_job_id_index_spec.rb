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

  it "displays one listing for each Job ID" do
    job1 = Job.create( job_id: 123 )
    job2 = Job.create( job_id: 123 )
    job3 = Job.create( job_id: 789 )
    job4 = Job.create( job_id: 789 )

    visit root_path

    expect( page ).to have_css( "li.job_link>a", count: 2 )
  end
end
