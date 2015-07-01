require 'rails_helper'

describe "existing_records/edit.html.erb" do
  @pid = "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60"

  it 'has an image' do
    assign(:existing_record, build(:existing_record))

    render

    expect(rendered).to have_css("img[src*='#{@pid}']")
  end

end