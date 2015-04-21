require 'rails_helper'

describe "visiting the image edit page" do
  
  before :each do
    visit root_url
    click_link( '123' )
    find('.image-entry', match: :first).click_link( 'Edit')
  end

  it "should not show the up and down arrows in the editor" do
    expect( page ).to_not have_content( '↓' )
    expect( page ).to_not have_content( '↑' )
  end

  it 'has an image' do
    expect( page ).to have_css( 'img' )
  end

  it 'is the correct dimension style' do
    expect( page ).to have_css( '.medium' )
  end

end