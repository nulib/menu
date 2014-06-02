class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :filename
      t.string :location

      t.timestamps
    end
  end
end
