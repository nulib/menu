class Image < ActiveRecord::Base
  belongs_to :job

  has_attached_file :proxy, :styles => { :thumb => [ "100x100", :jpg ], :medium => ["1000x1000", :jpg] }

  before_create :add_minimal_xml

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
    
  def validate_preferred_fields(nokogiri_doc)
    #date, title, agent
    invalid = []
    sets = nokogiri_doc.xpath( "//*" ).children[ 1 ].xpath( "./*" )

    sets.each do |node|
      if node.name == 'dateSet' 
        date = node.children.select { | child | child.name == "date" }
        earliestDate = date[0].children.select { | child | child.name == "earliestDate" }
        if earliestDate.blank?
          error = "Creation date is required"
          invalid << error
        end
      end
     
      if node.name == 'agentSet'
        agent = node.children.select { | child | child.name == "agent" }
        agentName = agent[0].children.select { | child | child.name == "name" }
        if agentName.blank?
          error = "Agent Name is required"
          invalid << error
        end
      end

      if node.name == 'titleSet'
        title = node.children.select { | child | child.name == "title" }
        if title[0].children.empty?
          error = "Title is required"
          invalid << error
        end
      end
    end
    invalid unless invalid.empty? 

  end

  def validate_vra
    doc = Nokogiri::XML(self.image_xml)

    invalid = []
    XSD.validate(doc).each do |error|
      invalid << "Validation error: #{error.message}"
    end
    preferred_fields = validate_preferred_fields(doc)
    invalid << preferred_fields unless preferred_fields.nil?

    invalid.each do |error|
      next if error =~ /is not a valid value of the list type 'xs:IDREFS'/
      next if error =~ /is not a valid value of the atomic type 'xs:IDREF'/
      #raise StandardError
    end

    invalid
  end


  private

    def add_minimal_xml
      self.image_xml = File.read( "#{Rails.root}/app/assets/xml/vra_minimal.xml" ) if self.image_xml.nil?
    end

end
