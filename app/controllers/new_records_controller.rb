require 'rest-client'
require 'delayed_job'

class NewRecordsController < ApplicationController
  before_action :set_new_record, only: [:show, :edit, :update, :destroy, :save_xml, :publish]
  layout "new_records"

  # GET /new_records
  # GET /new_records.json
  def index
    @new_records = NewRecord.all
  end

  # GET /new_records/1
  # GET /new_records/1.json
  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @new_record.xml }
    end
  end

  def get_record_id
    @new_record_id = GetNewRecords.find_or_create_new_record(params[:file])
    render json: {"new_record_id": @new_record_id}
  end


  # GET /new_records/new
  def new
    @new_record = NewRecord.new
  end

  # GET /new_records/1/edit
  def edit
  end


  # PATCH/PUT /new_records/1
  # PATCH/PUT /new_records/1.json
  def update
    respond_to do |format|
      if @new_record.update_attributes(new_record_params)
        format.html { redirect_to @new_record, notice: 'New Record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @new_record.errors, status: :unprocessable_entity }
      end
    end
  end


  # POST /new_records
  # POST /new_records.json
  def create
    @new_record = NewRecord.new(new_record_params)
    respond_to do |format|
      if @new_record.save
        format.html { redirect_to @new_record, notice: 'New record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @new_record }
      else
        format.html { render action: 'new' }
        format.json { render json: @new_record.errors, status: :unprocessable_entity }
      end
    end
  end


  # POST /new_records/1.xml
  def save_xml
    @new_record.xml = request.body.read
    respond_to do |format|
      if @new_record.save
        format.xml { redirect_to @new_record, notice: 'New Record was successfully updated.'  }
      else
        format.xml { render xml: @new_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_records/1
  # DELETE /new_records/1.json
  def destroy
    @new_record.destroy
    respond_to do |format|
      format.html { redirect_to !request.referer.nil? ? request.referer : new_records_url }
      format.json { head :no_content }
    end
  end

  def publish
    @new_record.xml = request.body.read

    if @new_record.save
      @new_record.xml = TransformXML.prepare_vra_xml( @new_record.xml, @new_record.filename )
      @accession_nbr = TransformXML.get_accession_nbr( @new_record.xml )

      if @new_record.valid_vra?
        @user_email = current_user.get_ldap_email
        Delayed::Job.enqueue PostToImagesJob.new(@new_record.xml, @new_record.path, @accession_nbr, @new_record.id, @user_email)

        job_url = "#{root_url}jobs/#{@new_record.job_id}"
        render json: {:localName => job_url}
      else
        errors = @new_record.validate_vra
        flash[:error] = errors
        render :template => "new_records/edit", :status => 400
      end
    else
      render edit: @new_record.errors, status: :unprocessable_entity
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_new_record
      @new_record = NewRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def new_record_params
      params.require(:new_record).permit(:filename, :location, :proxy, :job_id)
    end

    def dil_multiresimages_post( xml, path, accession_nbr )
      Delayed::Job.enqueue PostToImagesJob.new(xml, path, accession_nbr)
    end

end
