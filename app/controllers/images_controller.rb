require 'pry'
require 'rest-client'

class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy, :save_xml, :publish_record]

  # GET /images
  # GET /images.json
  def index
    GetImages.current_images
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

  def publish_record

    if @image.valid_vra?
      response = dil_api_call( @image.image_xml, @image.path )
      response_xml_doc = Nokogiri::XML( response )
      logger.debug response
      if response_xml_doc.at_xpath( '//pid' )
        @image.image_pid = response_xml_doc.at_xpath( '//pid' ).text
        @image.save
        redirect_to root_path
      else
        flash_messages = [ response_xml_doc.at_xpath( '//description' ).text ]
        flash_messages << "Image not saved"
        flash[:danger] = flash_messages
        render action: "edit" and return
      end
    else
      errors = @image.validate_vra
      flash[:danger] = errors
      render action: "edit" and return
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
        'https://127.0.0.1:3333/multiresimages/menu_publish',
        verify_ssl: OpenSSL::SSL::VERIFY_NONE ,

      ).post xml: xml , path: path


    end
end
