# frozen_string_literal: true

class GpxImportFailureNotifier < Noticed::Ephemeral
  deliver_by :email do |config|
    config.mailer = "UserMailer"
    config.method = "gpx_failure"
  end
end
