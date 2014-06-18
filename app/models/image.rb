class Image < ActiveRecord::Base
  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ] }

  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :job_id, :presence => true
  validates :filename, :uniqueness => true
end
