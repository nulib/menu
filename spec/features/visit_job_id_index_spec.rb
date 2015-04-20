require 'rails_helper'
#these test expect four directories of sample data in lib/assets/dropbox. 
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
    visit root_path
    
    expect(page).to have_selector(".job_link:nth-child(1) a", text: "123")
    expect(page).to have_selector(".job_link:nth-child(2) a", text: "234")
    expect(page).to have_selector(".job_link:nth-child(3) a", text: "456")
  end

  # lib/assets/dropbox should contain an empty directory called "555"
  # and a directory named "123" with images in it
  it "displays one listing for each job that has images" do

    visit root_path
    expect( page ).to_not have_link( "555" )

    visit root_path
    expect( page ).to have_link( "123" )
  end
end
