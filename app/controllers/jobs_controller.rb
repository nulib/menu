class JobsController < ApplicationController

  def index
    @jobs = Job.order(:job_id)
    flash[:notice] = "Menu will not allow publishing of cataloged records during Spring Break, from March 21st - 25th. Publishing will be re-enabled again on Monday, March 28th."
  end

  def browse
    @filesystem_location = MENU_CONFIG["images_filesystem_location"]
    @root = root_url
  end

  def import
    file_objects = params[:file_list]
    file_list = []

    file_objects.each do | item |
     file_list << item[1]["url"]
    end
    user_email = current_user.get_ldap_email

    Delayed::Job.enqueue ImportImagesJob.new(file_list, user_email, root_url)

    head :ok
  end

  def show
    @new_records = Job.find( params[ :id ]).new_records
  end

end
