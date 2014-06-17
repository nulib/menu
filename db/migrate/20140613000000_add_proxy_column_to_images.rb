class AddProxyColumnToImages < ActiveRecord::Migration
  def self.up
    add_attachment :images, :proxy
  end

  def self.down
    remove_attachment :images, :proxy
  end
end