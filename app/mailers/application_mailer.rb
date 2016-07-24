class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@marketplace.com"
  layout 'mailer'
end
