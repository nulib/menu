class AddRecordXmlColumnToExistingRecords < ActiveRecord::Migration
  def change
    add_column :existing_records, :record_xml, :text
  end
end
