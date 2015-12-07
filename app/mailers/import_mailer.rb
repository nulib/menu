class ImportMailer < ApplicationMailer

  def successful_import_email(files)
    @files= files
    @body = "Hello, your files #{@files} have been successfully imported into Menu. They are now available for metadata editing at menu.library.northwestern.edu."
    #need user who invoked delayed_job
   # mail(to: @user.current, cc: 'nfinzer@northwestern.edu', 'j-young2@northwestern.edu', subject: 'so great', body: @body)
    mail(to: 'nfinzer@northwestern.edu, jennifer.lindner@northwestern.edu', cc: 'j-young2@northwestern.edu', subject: 'Your Menu job has been succesfully imported', body: @body)

  end
end
