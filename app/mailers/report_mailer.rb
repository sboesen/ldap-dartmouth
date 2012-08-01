class ReportMailer < ActionMailer::Base
  default from: "Dartmouth.Security.Group.Reports@dartmouth.edu"
  def mail_pdf(email, attachment)
    attachments['security_report.pdf'] = attachment
    mail(to: email,
         subject: "Dartmouth Security Group Update (#{Date.today})")
  end
end
