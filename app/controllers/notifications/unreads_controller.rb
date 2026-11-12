# frozen_string_literal: true

module Notifications
  class UnreadsController < ReadsController
    private

    def mark_notifications(notifications)
      notifications.update(:read_at => nil)
    end
  end
end
