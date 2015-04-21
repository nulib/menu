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
    job2 = create(:job, job_id: 1 )
    visit root_path  

    expect( first('.job_link>a') ).to have_content( "1", exact: true )
  end

  it "displays one listing for each Job ID" do
    create(:job, job_id: 100)
    visit root_path
    expect( page ).to have_link( "100", count: 1 )
  end
end
