# frozen_string_literal: true

module Preferences
  class NotificationsPreferencesController < PreferencesController
    def show
      @notification_preferences = UserNotificationPreferences.new(current_user)
    end

    private

    def update_preferences
      throw "update_preferences"
      preferences = UserNotificationPreferences.new(current_user)
      preferences.update(params[:notifications])
    end
  end
end
