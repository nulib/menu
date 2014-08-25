class AddWorkXmlToImages < ActiveRecord::Migration
  def change
    add_column :images, :work_xml, :text
  end
end
