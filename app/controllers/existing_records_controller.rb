require 'rest-client'

class ExistingRecordsController < ApplicationController

  # GET /existing_records/1/edit
  def edit
    @existing_record = ExistingRecord.where(pid: params[:pid]).first_or_create
    if @existing_record.xml.blank?
      begin
        @existing_record.xml = dil_api_get_vra( params[:pid] )
      rescue
        flash[:error] = "The pid: \"#{params[:pid]}\" was not found in Repository|Images"
        redirect_to root_path
      end
    end
  end

  # PATCH/PUT /existing_records/1
  # PATCH/PUT /existing_records/1.json
  def update
    pid = params[:pid]
    @existing_record = ExistingRecord.find_by_pid(pid)
  	doc = Nokogiri::XML.parse( request.body.read )
    # do we have to remove the display if it's there?

    if doc.children.first.keys.include?('prefix')
      doc.children.first.delete('prefix')
    end


    #also, some of the records in fedora datastream don't seem to be in xml.
    #what then? fail? convert it? might not be valid record!!
    @existing_record.xml = doc
    if @existing_record.valid_vra?

  	 resp = dil_api_update_image( pid, doc.children )
      if resp.include?("Error")
        render action: 'edit', :pid => pid, :status => 400
      else
        @existing_record.save
        render json: {:localName => "#{root_url}"}
      end
    else
      errors = @existing_record.validate_vra
      flash[:error] = errors
      render action: 'edit', :pid => pid, :status => 400
    end
  end

  # POST /existing_records/1.xml
  def save_xml
    @existing_record = ExistingRecord.where(pid: params[:pid]).first_or_create
    @existing_record.xml = request.body.read
    respond_to do |format|
      if @existing_record.save
        format.xml { redirect_to action: "edit", pid: params[:pid],  notice: 'Record was successfully updated.'  }
      else
        format.xml { render xml: edit.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def dil_api_get_vra( pid )
      RestClient::Resource.new(
        "#{MENU_CONFIG["dil_img_service"]}/technical_metadata/#{pid}/VRA",
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).get
    end

    def dil_api_update_image( pid, xml )
      RestClient::Resource.new(
        MENU_CONFIG["dil_update"],
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).put({pid: pid, xml: xml})
    end

end
