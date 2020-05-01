module CosukaOpsworks
  class DiffMailer < ApplicationMailer
    default from: CosukaOpsworks.from_email if CosukaOpsworks.from_email.present?
    layout false

    def cron_diff(diff)
      body = <<~BODY
        ```diff
        #{diff}
        ```
      BODY

      mail to: CosukaOpsworks.diff_emails, subject: "[#{Socket.gethostname}] Cron diff", body: body, content_type: 'text/plain'
    end
  end
end
