require 'capybara/rspec'
require 'rails_helper'
require 'rake'


describe "updating existing record vra" do
  
  before :each do
    #visit root_url
    #need images to be running at localhost:3333
    dil_record = "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60"
  end

  after :all do
  	#return record to initial state
   	dil_record = "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60"
  	visit "http://localhost:3000/existing_records/edit/#{dil_record}"
  	page.fill_in 'xml_element6_text', :with => 'Bon Bon'
  	page.accept_confirm "This page is asking you to confirm that you want to leave - data you have entered may not be saved." do
     	find("#publishUrl").click
  	end
  	page.driver.quit
  	sleep(2)
  end

  it "lets you update an existing record" do
  	Capybara.default_driver = :selenium
		Capybara.default_wait_time = 5
		WebMock.allow_net_connect!
  	#for now use this inu: inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60
  	dil_record = "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60"
  	visit "http://localhost:3000/existing_records/edit/#{dil_record}"
  	#should confirm text is not already Dana Sculley
  	expect(page).to_not have_content("Dana Sculley")

  	page.fill_in 'xml_element6_text', :with => 'Dana Sculley'
  	page.accept_confirm "This page is asking you to confirm that you want to leave - data you have entered may not be saved." do
     	find("#publishUrl").click
  	end
  	#sleep(2)
  	visit "http://localhost:8983/fedora/objects/inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60/datastreams/VRA/content"
  	xml = Capybara.string(page.body)
		expect(xml).to have_content("Dana Sculley")
  end

end




