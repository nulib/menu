require 'rest-client'

class ExistingRecordsController < ApplicationController

	def edit
	    #hm. we'll call the dil_api with a pid, a get. then we need to pull its xml into the editor, from json, unless it gives us xml, look into using a respond_to? format with xml. 

	    #okay -- so, to get the edit page to get the right xml into the editor, it needs
	    #to pass in the pid ...

	    #check if it's in the db by pid, get it if so, if not, new? 
	 
	    @xml = dil_api_get_vra( params[:pid] )

	    #get image's id, get image, assign the response to its image_xml

	    #render edit, xml: @xml
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    #then we need to publish it, which requires a different method then the dil post. a dil put. which we don't have yet in images, we have a dil create or update fedora method that needs to be broken into create and update fedora.
    #@response = dil_api_get_vra( params[:pid] )
    #get image's id, get image, assign the response to its image_xml
    #render xml: @response

  end


  private

    def dil_api_get_vra( pid )
      RestClient::Resource.new(
        MENU_CONFIG["dil_fedora"],
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).get({:params => {pid: pid}})
    end

end