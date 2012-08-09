class ReportMailer < ActionMailer::Base
  default from: "Dartmouth.Security.Group.Reports@dartmouth.edu"
  def mail_pdf(email, message, attachment)
    attachments['security_report.xls'] = attachment
    mail(to: email, subject: "Dartmouth Security Group Update (#{Date.today})") do |format|
      if message.nil?
        format.text { render 'mail_pdf' }
      else
        format.text { render :text => message }
      end
    end
  end
end
