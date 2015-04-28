require 'rest-client'

class ExistingRecordsController < ApplicationController

	def edit
	 		@existing_record = ExistingRecord.where(pid: params[:pid]).first_or_create
	    @existing_record.record_xml = dil_api_get_vra( params[:pid] )
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
  	
  	dil_api_update_image( request.body.read )

  	#render edit again if failure 

    #then we need to publish it, which requires a different method then the dil post. a dil put. which we don't have yet in images, we have a dil create or update fedora method that needs to be broken into create and update fedora.

  end


  private

    def dil_api_get_vra( pid )
      RestClient::Resource.new(
        MENU_CONFIG["dil_fedora"],
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).get({:params => {pid: pid}})
    end

    def dil_api_update_image( xml )
      RestClient::Resource.new(
        MENU_CONFIG["dil_update"],
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).put({xml: xml})
    end    

end