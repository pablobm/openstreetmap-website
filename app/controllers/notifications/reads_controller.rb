# frozen_string_literal: true

module Notifications
  class ReadsController < ApplicationController
    before_action :authorize_web
    before_action :set_locale

    authorize_resource :class => false

    before_action :check_database_writable

    def create
      notification_ids = Array.wrap(params[:notification_ids] || params[:notification_id])

      notifications = current_user.web_notifications.where(:id => notification_ids)

      mark_notifications(notifications)

      redirect_back_or_to notifications_path
    end

    private

    def mark_notifications(notifications)
      notifications.update(:read_at => Time.zone.now)
    end
  end
end
