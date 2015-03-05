require 'rest-client'

class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :save_xml, :publish]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @image.image_xml }
    end
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render action: 'show', status: :created, location: @image }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update_attributes(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /images/1.xml
  def save_xml
    @image.image_xml = request.body.read
    respond_to do |format|
      if @image.save
        format.xml { redirect_to @image, notice: 'Image was successfully updated.'  }
      else
        format.xml { render xml: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end


  def publish
    @image.image_xml = request.body.read

    if @image.save
      @image.image_xml = TransformXML.add_display_elements( @image.image_xml )
      if @image.valid_vra?
          full_path = "#{Rails.root}/" + "#{@image.path}"
          response = dil_api_call( @image.image_xml, full_path )
          response_xml_doc = Nokogiri::XML( response )
          if response_xml_doc.at_xpath( '//pid' ) && /Publish successful/.match(response_xml_doc)
            destination = @image.completed_destination
            FileUtils.mkdir_p(destination) unless File.exists?(destination)
            FileUtils.mv(@image.path, "#{destination}/#{@image.filename}") unless Rails.env.development?
            @image.destroy
            redirect_to root_path
          else
            flash_messages = [ response_xml_doc.at_xpath( '//description' ).text.truncate( 50 ) ]
            flash_messages << "Image xml not published"
            flash[:error] = flash_messages
            render :edit
          end
      else
        errors = @image.validate_vra
        flash[:error] = errors
        render :template => "images/edit", :status => 400
      end
    else
      render edit: @image.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:filename, :location, :proxy, :job_id)
    end

    def dil_api_call( xml, path )

      RestClient::Resource.new(
        MENU_CONFIG["dil_url"],
        verify_ssl: OpenSSL::SSL::VERIFY_NONE ,

      ).post xml: xml , path: path


    end
end
