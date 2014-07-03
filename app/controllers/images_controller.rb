require 'pry'

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
    @image.image_xml = 
'<vra:vra xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:vra="http://www.vraweb.org/vracore4.htm" xsi:schemaLocation="http://www.vraweb.org/vracore4.htm http://www.vraweb.org/projects/vracore4/vra-4.0-restricted.xsd">
    <vra:image>
        <!--Agents-->
        <vra:agentSet>
            <vra:display>Stanley, Frederic ; United States. War Department. Bureau of Public Relations ; United States. Army ; U.S. G.P.O.</vra:display>
            <vra:agent>
                <vra:name type="personal" vocab="lcnaf">Stanley, Frederic</vra:name>
                <vra:attribution/></vra:agent>
            <vra:agent>
                <vra:name type="corporate" vocab="lcnaf">United States. War Department. Bureau of Public Relations</vra:name>
                <vra:attribution/></vra:agent>
            <vra:agent>
                <vra:name type="corporate" vocab="lcnaf">United States. Army</vra:name>
                <vra:attribution/></vra:agent>
            <vra:agent>
                <vra:name type="corporate" vocab="lcnaf">U.S. G.P.O.</vra:name>
            </vra:agent>
        </vra:agentSet>
        <vra:culturalContextSet>
            <vra:display/>
            <vra:culturalContext/></vra:culturalContextSet>
        <!--Dates-->
        <vra:dateSet>
            <vra:display>1943</vra:display>
            <vra:date type="creation">
                <vra:earliestDate>1943</vra:earliestDate>
            </vra:date>
        </vra:dateSet>
        <!--Description-->
        <vra:descriptionSet>
            <vra:display>"War Department, Public Relations Bureau"--Monthly catalog 1943, p. 1509. ; U.S. Army insignia appears in lower right corner. ; A soldier in helmet and combat uniform carries a wooden crate of ammunition as cannon artillery fires in the background.</vra:display>
            <vra:notes>"War Department, Public Relations Bureau"--Monthly catalog 1943, p. 1509. ; U.S. Army insignia appears in lower right corner. ; A soldier in helmet and combat uniform carries a wooden crate of ammunition as cannon artillery fires in the background.</vra:notes>
            <vra:description>"War Department, Public Relations Bureau"--Monthly catalog 1943, p. 1509.</vra:description>
            <vra:description>U.S. Army insignia appears in lower right corner.</vra:description>
            <vra:description>A soldier in helmet and combat uniform carries a wooden crate of ammunition as cannon artillery fires in the background.</vra:description>
        </vra:descriptionSet>
        <vra:inscriptionSet>
            <vra:display/>
            <vra:inscription>
                <vra:text/></vra:inscription>
        </vra:inscriptionSet>
        <!--Location-->
        <vra:locationSet>
            <vra:display>Washington, D.C. ; World War II Poster Collection at Northwestern University Library ; U.S. Superintendent of Documents Classification number: W107.8:Am6 ;</vra:display>
            <vra:location type="creation">
                <vra:name type="geographic">Washington, D.C.</vra:name>
            </vra:location>
            <vra:location type="repository">
                <vra:name type="geographic">World War II Poster Collection at Northwestern University Library</vra:name>
            </vra:location>
        </vra:locationSet>
        <!--Materials-->
        <vra:materialSet>
            <vra:display>1 poster</vra:display>
            <vra:material>1 poster :</vra:material>
        </vra:materialSet>
        <!--Measurements-->
        <vra:measurementsSet>
            <vra:display>101 x 72 cm.</vra:display>
            <vra:measurements>101 x 72 cm</vra:measurements>
        </vra:measurementsSet>
        <!--Relation-->
        <vra:relationSet>
            <vra:display/>
        </vra:relationSet>
        <!--Rights-->
        <vra:rightsSet>
            <vra:display>Materials published by the U.S. Government Printing Office are in the public domain and, as such, not subject to copyright restriction. However, the Library requests users to cite the URL and Northwestern University Library if they wish to reproduce images from its poster database.</vra:display>
            <vra:rights type="publicDomain">
                <vra:rightsHolder>Public Domain</vra:rightsHolder>
                <vra:text>Materials published by the U.S. Government Printing Office are in the public domain and, as such, not subject to copyright restriction. However, the Library requests users to cite the URL and Northwestern University Library if they wish to reproduce images from its poster database.</vra:text>
            </vra:rights>
        </vra:rightsSet>
        <!--Style Period-->
        <vra:stylePeriodSet>
            <vra:display/>
            <vra:stylePeriod/></vra:stylePeriodSet>
        <!--Subjects-->
        <vra:subjectSet>
            <vra:display>World War, 1939-1945--War work--United States--Posters ; War posters, American ; Defense work</vra:display>
            <vra:subject>
                <vra:term type="descriptiveTopic">World War, 1939-1945</vra:term>
            </vra:subject>
            <vra:subject>
                <vra:term type="descriptiveTopic">War posters, American</vra:term>
            </vra:subject>
            <vra:subject>
                <vra:term type="descriptiveTopic">Defense work</vra:term>
            </vra:subject>
        </vra:subjectSet>
        <vra:techniqueSet>
            <vra:display/>
            <vra:technique/></vra:techniqueSet>
        <!-- Titles -->
        <vra:titleSet>
            <vra:display>"--Pass the ammunition" : the Army needs more lumber ; Army needs more lumber</vra:display>
            <vra:title pref="true">"--Pass the ammunition" :</vra:title>
            <vra:title pref="false">Army needs more lumber</vra:title>
        </vra:titleSet>
        <vra:worktypeSet>
            <vra:display/>
            <vra:worktype/></vra:worktypeSet>
    </vra:image>
</vra:vra>'
    url = URI.parse( 'https://127.0.0.1:3333/multiresimages/create_update_fedora_object' )
    req = Net::HTTP::Post.new( url.path )
    req.body = @image.image_xml
    sock = Net::HTTP.new( url.host, 3333 )
    sock.use_ssl = true
    # sock.cert_store = OpenSSL::X509::Store.new
    # sock.cert_store.set_default_paths
    sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = ''
    sock.start { |http| res = http.request( req ) }
    res.body
    redirect_to root_path
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
end
