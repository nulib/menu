class PublicationMailer < ApplicationMailer

  def successful_publication_email(file, pid, user_email)
    @file = file
    @body = "Hello, your file #{@file} was successfully published to the Images application. You can view it here: #{MENU_CONFIG['dil_url']}/#{pid}"

    mail(to:"#{user_email},jennifer.lindner@northwestern.edu", from: "repository@northwestern.edu", subject: "Your Images record was successfully published", body: @body)
  end

    def failed_publication_email(file, user_email)
    @file = file
    @body = "Hello, the file #{@file} did not get published to the Images application. Please try again or contact the support team."

    mail(to:"#{user_email},jennifer.lindner@northwestern.edu", from: "repository@northwestern.edu", subject: "Your Images record did not get published", body: @body)
  end
end
