namespace :menu do

#these should go into a module

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

  def dil_api_update_image( pid, xml, move_your_tiff=true )
    RestClient::Resource.new(
      MENU_CONFIG["dil_update_with_tiff_move"],
      verify_ssl: OpenSSL::SSL::VERIFY_NONE
    ).put({pid: pid, xml: xml})
  end



  desc "task to update current list of images in the db. Should be kicked off by a cron job"
  task :update_image_list => :environment do
    GetImages.current_images
  end

  desc "update the metadata for a list of records"
  task :update_the_metadata_for_a_list_of_records => :environment do
    records = [
      "inu:dil-947cf7ac-0492-47be-b0ce-7dce22d49f54",
      "inu:dil-af3c7e97-8fee-4a3d-8584-913fd3089c92",
      "inu:dil-fc8c3d36-22e7-4072-a8d4-6d2665147d24",
      "inu:dil-d3d3680d-622d-487e-be2f-0a6fa8dccb09",
      "inu:dil-zz6c49cc99-0aba-4c13-9126-fdb1889d9883",
      "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60",
      "inu:dil-fbb74b25-0bde-48e2-92c9-cea01c55c4f5",
      "inu:dil-cffada80-57f3-4d98-a0ee-e73048943f90",
      "inu:dil-c1d57bb2-d938-40c9-9500-603f3d03264b",
      "inu:dil-zza1b27840-c9ca-41a5-a39d-531621421d6d",
      "inu:dil-7ab2b6b9-1583-45e5-9e87-2c50d4360ff5",
      "inu:dil-47ab8b6d-b0ef-494f-91ac-5906560fa90b",
      "inu:dil-ae1536f3-0f95-4267-aeae-d32238d4312f",
      "inu:dil-b5014da9-a0bd-4339-87fd-5672581204f1",
      "inu:dil-bf9b747d-a933-4cf5-b952-357456dd5790",
      "inu:dil-c417c5aa-af70-4cf7-8b40-efbd08a5f70f",
      "inu:dil-f36a77f8-e2af-4139-b5e6-e0e9cf09ab63",
      "inu:dil-zz614ec515-86cd-49cf-98e7-e91c43d48c56"
    ]

    unfound_pids = []
    unparsable_xml = []
    unpublished_pids = []

    records.each do | dil |
      begin
        xml = dil_api_get_vra(dil)
      rescue => e
        unfound_pids << "dil pid #{dil} couldn't be found, error: #{e}. \n"
      end

      begin
        doc = Nokogiri::XML.parse( xml )
      rescue => e
        unparsable_xml << "dil pid #{dil} had nokogiri problem #{e}. \n"
      end

      begin
        dil_api_update_image( dil, doc.children )
      rescue => e
        unpublished_pids << "dil pid #{dil} was not published, error: #{e}. \n"
      end
    end

    unless unfound_pids.empty?
      ImportMailer.failed_import_email(unfound_pids, "jennifer.lindner@northwestern.edu").deliver_now
    end

    unless unparsable_xml.empty?
     ImportMailer.failed_import_email(unparsable_xml, "jennifer.lindner@northwestern.edu").deliver_now
    end

    unless unpublished_pids.empty?
      ImportMailer.failed_import_email(unpublished_pids, "jennifer.lindner@northwestern.edu").deliver_now
    end

  end

# if this was app code i'd be in big big trouble for duplicating almost all of the above method
# but it isn't, this is a one-time utility and it's easier so that's that

  desc "update metadata and move tiffs for a list of records"
  task :update_metadata_and_move_tiffs_for_a_list_of_records => :environment do
    metadata_updates = [
      "inu:dil-947cf7ac-0492-47be-b0ce-7dce22d49f54",
      "inu:dil-af3c7e97-8fee-4a3d-8584-913fd3089c92",
      "inu:dil-fc8c3d36-22e7-4072-a8d4-6d2665147d24",
      "inu:dil-d3d3680d-622d-487e-be2f-0a6fa8dccb09",
      "inu:dil-zz6c49cc99-0aba-4c13-9126-fdb1889d9883",
      "inu:dil-c5275483-699b-46de-b7ac-d4e54112cb60",
      "inu:dil-fbb74b25-0bde-48e2-92c9-cea01c55c4f5",
      "inu:dil-cffada80-57f3-4d98-a0ee-e73048943f90",
      "inu:dil-c1d57bb2-d938-40c9-9500-603f3d03264b",
      "inu:dil-zza1b27840-c9ca-41a5-a39d-531621421d6d",
      "inu:dil-7ab2b6b9-1583-45e5-9e87-2c50d4360ff5",
      "inu:dil-47ab8b6d-b0ef-494f-91ac-5906560fa90b",
      "inu:dil-ae1536f3-0f95-4267-aeae-d32238d4312f",
      "inu:dil-b5014da9-a0bd-4339-87fd-5672581204f1",
      "inu:dil-bf9b747d-a933-4cf5-b952-357456dd5790",
      "inu:dil-c417c5aa-af70-4cf7-8b40-efbd08a5f70f",
      "inu:dil-f36a77f8-e2af-4139-b5e6-e0e9cf09ab63",
      "inu:dil-zz614ec515-86cd-49cf-98e7-e91c43d48c56"
    ]

    unfound_pids = []
    unparsable_xml = []
    unpublished_pids = []

    records.each do | dil |
      begin
        xml = dil_api_get_vra(dil)
      rescue => e
        unfound_pids << "dil pid #{dil} couldn't be found, error: #{e}. \n"
      end

      begin
        doc = Nokogiri::XML.parse( xml )
      rescue => e
        unparsable_xml << "dil pid #{dil} had nokogiri problem #{e}. \n"
      end

      begin
        if doc.xpath("//vra:descriptionSet/vra:notes").text.include?("Job:")
          job_number = doc.xpath("//vra:descriptionSet/vra:notes").text.split("Job:")[1]
          #will need to rename all tiffs to same extension
          move_your_tiff = ["#{dil}.tiff", "/images_dropbox/_completed/#{job_number}/#{dil}.tiff"]
          dil_api_update_image( dil, doc.children, move_your_tiff )
      end
      rescue => e
        unpublished_pids << "dil pid #{dil} was not published, error: #{e}. \n"
      end
    end

    unless unfound_pids.empty?
      ImportMailer.failed_import_email(unfound_pids, "jennifer.lindner@northwestern.edu").deliver_now
    end

    unless unparsable_xml.empty?
     ImportMailer.failed_import_email(unparsable_xml, "jennifer.lindner@northwestern.edu").deliver_now
    end

    unless unpublished_pids.empty?
      ImportMailer.failed_import_email(unpublished_pids, "jennifer.lindner@northwestern.edu").deliver_now
    end

  end


  desc "make new jobs and records of all files in dropbox"
  task :make_records_for_all_tiffs => :environment do
    GetNewRecords.current_new_records
  end

end
