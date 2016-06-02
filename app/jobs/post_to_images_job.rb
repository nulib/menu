class PostToImagesJob < Struct.new(:xml, :path, :accession_nbr, :new_record_id, :user_email)
  def perform
    resource = RestClient::Resource.new(
      MENU_CONFIG["dil_url"],
      verify_ssl: OpenSSL::SSL::VERIFY_NONE,
    )
    response = resource.post xml: xml , path: path , accession_nbr: accession_nbr, from_menu: true
    response_xml_doc = Nokogiri::XML( response )
    if response_xml_doc.at_xpath( '//pid' ) && /Publish successful/.match(response_xml_doc)
      @new_record = NewRecord.find(new_record_id)
      @pid_xml = response_xml_doc.at_xpath( '//pid' ).to_s
      @pid = @pid_xml.gsub(/<pid>/, '').gsub(/<\/pid>/, '')
      destination = @new_record.completed_destination
      FileUtils.mkdir_p(destination) unless File.exists?(destination)
      if ["staging", "production"].include? "#{Rails.env}"
        FileUtils.mv(@new_record.path, "#{destination}/#{@new_record.filename}")
      end
      @new_record.destroy

      Delayed::Worker.logger.info "Successful publication of #{@new_record.filename}"
      PublicationMailer.successful_publication_email(@new_record.filename, @pid, user_email).deliver_now
    else

      Delayed::Worker.logger.error "Failed publication of #{@new_record.filename}"
      PublicationMailer.failed_publication_email(@new_record.filename, user_email).deliver_now
    end
  end

end
