require 'rest-client'

class ExistingRecordsController < ApplicationController

	def edit
	 		@existing_record = ExistingRecord.where(pid: params[:pid]).first_or_create
	    @existing_record.record_xml = dil_api_get_vra( params[:pid] )
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update  	
  	pid = params[:pid]
  	doc = Nokogiri::XML.parse( request.body.read )
  	doc.children[0]['prefix'] = "//vra:agentSet/vra:display"
  	doc.children[0]['prefix'] = "/vra:vra/vra:work:"

  	resp = dil_api_update_image( pid, doc.children )

	  if resp.include?("Error")
	  	render action: 'edit', :pid => pid      
    else
      render json: {:localName => "#{root_url}"}
    end
  end


  private

    def dil_api_get_vra( pid )
      RestClient::Resource.new(
        MENU_CONFIG["dil_fedora"],
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).get({:params => {pid: pid}})
    end

    def dil_api_update_image( pid, xml )
      RestClient::Resource.new(
        MENU_CONFIG["dil_update"],
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).put({pid: pid, xml: xml})
    end    

end