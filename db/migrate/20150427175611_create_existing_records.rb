class CreateExistingRecords < ActiveRecord::Migration
  def change
    create_table :existing_records do |t|
      t.string :pid
      t.string :accession_number
    end
  end
end
