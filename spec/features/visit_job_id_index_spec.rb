require 'rails_helper'

describe "visiting the home page" do

  it "provides a link to the Cataloging Guidelines" do
    visit root_path

    expect( page ).to have_link( "Cataloging Guidelines" )
  end

  it "displays a Job ID header" do
    visit root_path

    expect( page ).to have_content( "Job IDs" )
  end

  it "displays a list of linked Job IDs" do
    visit root_path

    expect( page ).to have_css( "li.job_link>a" )
  end

  it "orders the list of jobs by Job ID" do
    job2 = create(:job, job_id: 7890 )
    visit root_path

    expect( first('.job_link>a') ).to have_content( "7890", exact: true)
    job2.delete
  end

  it "displays one listing for each Job ID" do
    job1 = create(:job)
    visit root_path

    expect( page ).to have_link( job1.job_id, count: 1 )
    job1.delete
  end
end
