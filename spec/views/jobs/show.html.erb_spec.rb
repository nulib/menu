require 'rails_helper'

describe 'jobs/show.html.erb', :type => :view do

  it 'contains links that say Delete instead of Destroy' do
    new_record1 = create(:new_record)
    new_record2 = create(:new_record)
    @new_records = [new_record1, new_record2]

    render

    expect(rendered).to have_link 'Delete'
  end

  it "displays the user-given job_id, not the rails job_id in new_record data" do
      new_record1 = create(:new_record)
      new_record2 = create(:new_record)
      @new_records = [new_record1, new_record2]

    render
    expect(rendered).to have_content  new_record1.job.job_id
  end

end

