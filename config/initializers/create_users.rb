# frozen_string_literal: true

require "active_support/testing/time_helpers"

Rails.application.config.to_prepare do
  admin = User.find_by(:display_name => "admin")
  admin&.roles&.find_or_create_by!(:role => "administrator") do |record|
    record.granter_id = admin.id
  end
end
