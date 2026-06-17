# frozen_string_literal: true

module Notifications
  class StatusesController < ApplicationController
    before_action :authorize_web
    authorize_resource :class => :notification
    before_action :check_database_writable

    def update
      ids_to_mark_read =
        params
        .expect(:notifications => {})
        .to_unsafe_h
        .select { |_k, v| v == "read" }
        .keys
        .map { |id| Integer(id) }

      current_user.notifications.where(:id => ids_to_mark_read).update(:read_at => Time.zone.now)

      redirect_back_or_to notifications_path
    end
  end
end
