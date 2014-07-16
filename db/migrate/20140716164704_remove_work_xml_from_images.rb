class RemoveWorkXmlFromImages < ActiveRecord::Migration
  def change
    remove_column :images, :work_xml
  end
end
