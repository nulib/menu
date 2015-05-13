require 'rest-client'

class ExistingRecordsController < ApplicationController

  # GET /existing_records/
	def edit
	 		@existing_record = ExistingRecord.where(pid: params[:pid]).first_or_create
      # resp = dil_api_get_vra( params[:pid] )
      # doc = Nokogiri::XML.parse( resp)
      # if doc.search("work")
      #   render Error
      # end
	    @existing_record.record_xml = dil_api_get_vra( params[:pid] )
  end

  # PATCH/PUT /existing_records/1
  # PATCH/PUT /existing_records/1.json
  def update  	
  	pid = params[:pid]
    @existing_record = ExistingRecord.find_by_pid(pid)
  	doc = Nokogiri::XML.parse( request.body.read )

    #also, some of the records in fedora datastream don't seem to be in xml. 
    #what then? fail? convert it? might not be valid record!!

  	doc.children[0]['prefix'] = "//vra:agentSet/vra:display"
  	#doc.children[0]['prefix'] = "/vra:vra/vra:work:"
    @existing_record.record_xml = doc
    if @existing_record.valid_vra?
  	 resp = dil_api_update_image( pid, doc.children )
      if resp.include?("Error")
        render action: 'edit', :pid => pid, :status => 400        
      else
        # @existing_record.save
        render json: {:localName => "#{root_url}"}
      end
    else
      errors = @existing_record.validate_vra
      flash[:error] = errors
      render action: 'edit', :pid => pid, :status => 400  
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