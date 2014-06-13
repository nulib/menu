class Image < ActiveRecord::Base
  has_attached_file :proxy, :styles => { :thumb => "100x100" }

  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :filename, :uniqueness => true
end
