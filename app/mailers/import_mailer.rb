class ImportMailer < ApplicationMailer

  def successful_import_email(files, user_email)
    @files= files
    @body = "Hello, your files #{@files} have been successfully imported into Menu. They are now available for metadata editing at menu.library.northwestern.edu."
    #need user who invoked delayed_job
    mail(to:"#{user_email},jennifer.lindner@northwestern.edu", subject: "Your Menu job has been succesfully imported", body: @body)
  end
end
