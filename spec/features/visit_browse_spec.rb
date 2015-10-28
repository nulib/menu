require 'rails_helper'


WebMock.disable_net_connect!(:allow_localhost => true)

#these test expect four directories of sample data in lib/assets/dropbox.
feature "browsing and importing images into Menu" do
  include ActiveJob::TestHelper
    scenario "cataloger browses all images available in dropbox", :js => true do

            visit "http://localhost:3000"
            fill_in 'user_username', :with => Rails.application.secrets["test_user_id"]
            fill_in 'user_password', :with => Rails.application.secrets["test_user_password"]

            click_button('Log in')

            visit "http://localhost:3000/jobs/browse"
            click_button("Browse")

            click_link("123")
            # click_link("123_internet.tiff")
            # click_link("123_Rodinia.tiff")
            # click_link("123_technology.tiff")

            click_link("456")
            click_link("456_internet.tiff")
            # click_link("456_Rodinia.tiff")
            # click_link("456_technology.tiff")


            click_link("61120151061120151")
            click_link("61120151061120151_internet.tiff")
            # click_link("61120151061120151_Rodinia.tiff")
            # click_link("61120151061120151_technology.tiff")

            click_link("789")
            click_link("789_internet.tiff")
            # click_link("789_Rodinia.tiff")
            # click_link("789_technology.tiff")

              #then do some logic to find all links of ev-selected all('.collapsed.leaf.ev-selected'); if their data-tt-id="/browse/file_system/123/123_internet.tiff"
              #doesn't include 456 or 789 or 123 or 6112 don't include them in array (use select to filter?)

           # end
            sleep(3)
            click_button('Submit')

            puts "enqueued jobs?? #{enqueued_jobs.size}"
    end
end