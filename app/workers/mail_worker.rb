require 'open-uri'
class MailWorker 
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(search_id)
    search = Search.find(search_id)
    attachment_url = Rails.application.routes.url_helpers.search_url(search, format: 'xls', :host => 'localhost:3000')
    Rails.logger.info "Sending attachment - #{attachment_url}"
    attachment = open(attachment_url) { |f| f.read }
    message = search.email_message
    Rails.logger.info "Sending with message: #{message.to_s}"
    search.user_emails.each do |email|
      email = email.email
      ReportMailer.mail_pdf(email, message, attachment).deliver
    end
  end
end
