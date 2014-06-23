class Image < ActiveRecord::Base
  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ], :medium => ["1000x1000", :jpg] }

  before_create :add_minimal_xml
  
  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :job_id, :presence => true
  validates :filename, :uniqueness => true

  private

    def add_minimal_xml
      self.xml = File.read( "#{Rails.root}/app/assets/xml/vra_minimal.xml" ) if self.xml.nil?
    end
end
