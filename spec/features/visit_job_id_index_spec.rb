require 'rails_helper'
#these test expect four directories of sample data in lib/assets/dropbox.
describe "visiting the home page" do

  before :all do
    Menu::Application.load_tasks
    Rake::Task["menu:make_records_for_all_tiffs"].invoke  
  end

  before :each do
    visit root_url
    within("#new_user") do
      fill_in 'user_username', :with => Rails.application.secrets["test_user_id"]
      fill_in 'user_password', :with => Rails.application.secrets["test_user_password"]
    end
    click_button('Log in')
  end

  it "provides a link to the Cataloging Guidelines" do
    expect( page ).to have_link( "Cataloging Guidelines" )
  end

  it "provides a link to the Help documentation" do
    expect( page ).to have_link( "Help Document" )
  end

  it "contains a search_box for existing_records" do
    expect( find('.navbar-form') ).to have_button( 'Search' )
  end

  it "contains a link to the browse images page in the navbar" do
    expect( find('.navbar') ).to have_link( 'Import Images' )
  end

  it "displays a Job ID header" do
    expect( page ).to have_content( "Job IDs" )
  end

  it "displays a list of linked Job IDs" do
    expect( page ).to have_css( "li.job_link>a" )
  end

  it "orders the list of jobs by Job ID" do

    expect(page).to have_selector(".job_link:nth-child(1) a", text: "123")
    expect(page).to have_selector(".job_link:nth-child(2) a", text: "456")
    expect(page).to have_selector(".job_link:nth-child(3) a", text: "789")
  end

  # lib/assets/dropbox should contain an empty directory
  # and a directory named "123" with new_records in it
  it "displays one listing for each job that has new_records" do
    expect( page ).to_not have_content( "(0)" )

    visit root_path
    expect( page ).to have_link( "456" )
  end

  it "can handle an 18-digit job id" do
    expect(page).to have_selector(".job_link:nth-child(4) a", text: "61120151061120151")
    expect(page).to_not have_content("is out of range for ActiveRecord")
  end
end
