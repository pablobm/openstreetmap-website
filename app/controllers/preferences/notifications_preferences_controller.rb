# frozen_string_literal: true

module Preferences
  class NotificationsPreferencesController < PreferencesController
    private

    def update_preferences
      current_user.languages = params[:user][:languages].split(",")
      current_user.save
    end
  end
end
