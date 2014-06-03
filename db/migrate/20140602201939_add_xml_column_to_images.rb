class AddXmlColumnToImages < ActiveRecord::Migration
  def change
    add_column "images", "xml", :text
  end
end
