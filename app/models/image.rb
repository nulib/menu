class Image < ActiveRecord::Base
  belongs_to :job

  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ], :medium => ["1000x1000", :jpg] }

  before_create :add_minimal_xml

  include Validator

  validates_attachment_content_type :proxy, :content_type => "image/tiff"
  validates :job_id, :presence => true
  validates :filename, :uniqueness => true

  def job_id_display
    self.job.job_id
  end

  def path
    "#{location}/#{filename}"
  end

  def completed_destination
    completed_directory = "_completed"
    "#{MENU_CONFIG['images_dir']}/#{completed_directory}/#{ self.job.job_id }"
  end

  def valid_vra?
    true if validate_vra.empty?
  end


  private

    def add_minimal_xml
      self.image_xml = Nokogiri::XML.parse(File.read( "#{Rails.root}/app/assets/xml/vra_minimal.xml" )) if self.image_xml.nil?
    end

end
