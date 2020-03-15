class ApplicationMailer < ActionMailer::Base
  default from: "namedropped <notification@namedropped.co>"
  layout 'mailer'

  ActionMailer::Base.smtp_settings = {
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :domain => 'namedropped.co',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain
  }
end
