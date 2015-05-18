class ChangeImageXmlAndRecordXmlToXml < ActiveRecord::Migration
  def up
  	rename_column :images, :image_xml, :xml
  	rename_column :existing_records, :record_xml, :xml
  end

  def down
  	rename_column :images, :xml, :image_xml
  	rename_column :existing_records, :xml, :record_xml
  end
end
