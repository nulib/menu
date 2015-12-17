class ImportMailer < ApplicationMailer

  def successful_import_email(files, user_email, root_url)
    @files= files
    @body = "Hello, your files #{@files} have been successfully imported into Menu. They are now available for metadata editing at #{root_url}."
    #need user who invoked delayed_job
    mail(to:"#{user_email},jennifer.lindner@northwestern.edu", from: "Brendan-Quinn@northwestern.edu", subject: "Your Menu job has been successfully imported", body: @body)
  end

    def failed_import_email(files, user_email)
    @files= files
    @body = "Hello, the files #{@files} did not get imported into Menu. Please try again or contact the support team."
    #need user who invoked delayed_job
    mail(to:"#{user_email},jennifer.lindner@northwestern.edu", from: "Brendan-Quinn@northwestern.edu", subject: "Your Menu job did not get imported", body: @body)
  end
end
