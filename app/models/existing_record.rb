class ExistingRecord < ActiveRecord::Base
	
	include Validator

	def valid_vra?
    true if validate_vra.empty?
  end

  def validate_vra
    doc = Nokogiri::XML(self.xml)

    invalid = []
    XSD.validate(doc).each do |error|
      invalid << "Validation error: #{error.message}"
    end

    missing_fields = validate_required_fields(doc)
    invalid << missing_fields unless missing_fields.nil?

    missing_or_invalid = invalid.reject do |error|
      error.include?("inu:dil") 
    end
    puts " you are missing or invalid! #{missing_or_invalid}"
    missing_or_invalid
  end

end