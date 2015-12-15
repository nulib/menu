require 'rails_helper'

describe "visiting the new_record edit page" do

  before :each do
    visit root_url

    within("#new_user") do
      fill_in 'user_username', :with => Rails.application.secrets["test_user_id"]
      fill_in 'user_password', :with => Rails.application.secrets["test_user_password"]
    end
    click_button('Log in')

    click_link( '456' )
    find('.new-record-entry', match: :first).click_link( 'Edit')
  end

  it "should not show the up and down arrows in the editor" do
    expect( page ).to_not have_content( '↓' )
    expect( page ).to_not have_content( '↑' )
  end

  it 'has an image' do
    expect( page ).to have_css( 'img' )
  end

  it 'is the correct dimension style' do
    expect( page ).to have_css( '.original' )
  end

end