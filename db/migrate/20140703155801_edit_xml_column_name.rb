class EditXmlColumnName < ActiveRecord::Migration
  def change
    rename_column :images, :xml, :image_xml
  end
end
