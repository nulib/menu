class ExistingRecord < ActiveRecord::Base
	
	include Validator

	def valid_vra?
    true if validate_vra.empty?
  end

  def validate_vra
    doc = Nokogiri::XML(self.image_xml)

    invalid = []
    XSD.validate(doc).each do |error|
      invalid << "Validation error: #{error.message}"
    end
    required_fields = validate_required_fields(doc)
    invalid << required_fields unless required_fields.nil?

    invalid.each do |error|
      next if error =~ /is not a valid value of the list type 'xs:IDREFS'/
      next if error =~ /is not a valid value of the atomic type 'xs:IDREF'/
      #raise StandardError
    end

    invalid
  end

end