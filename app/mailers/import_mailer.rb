class ImportMailer < ApplicationMailer

  def successful_import_email(job)
    @job = job
    @body = "right on"
    #need user who invoked delayed_job
   # mail(to: @user.current, cc: 'nfinzer@northwestern.edu', 'j-young2@northwestern.edu', subject: 'so great', body: @body)
    mail(to: 'jennifer.lindner@northwestern.edu', subject: 'so great', body: @body)

  end
end
