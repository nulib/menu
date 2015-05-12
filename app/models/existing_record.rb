class ExistingRecord < ActiveRecord::Base
	
	include Validator

	def valid_vra?
    true if validate_vra.empty?
  end

end