require 'rails_helper'

describe GetNewRecords do

  it "persists valid new_records to the DB" do
    GetNewRecords.add_job_id_to_random_files
    GetNewRecords.current_new_records
    expect( NewRecord.all.count ).to eql( 12 )
    GetNewRecords.remove_job_id_from_file_name
  end

  it "rejects invalid new_records from persisting to the DB" do
    `touch #{Rails.root}/spec/dropbox_invalid/invalid.tiff`
    GetNewRecords.find_or_create_new_record("#{Rails.root}/spec/dropbox_invalid/invalid.tiff")
    expect(NewRecord.find_by_filename("invalid.tiff").nil?).to be true
  end

  # The empty array sent to the remove_stale_new_records function implies that there are no
  # new_record files on the file system, so the NewRecord model that was just created is stale
  it "removes stale new_records" do
    NewRecord.create(filename: "cool_test", job_id: "98765")
    GetNewRecords.remove_stale_new_records( [] )
    expect( NewRecord.all.count ).to eql( 0 )
  end

end
