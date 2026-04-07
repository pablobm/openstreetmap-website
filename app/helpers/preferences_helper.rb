# frozen_string_literal: true

module PreferencesHelper
  class UserNotificationPreference
    def initialize(user, event_name)
      @user = user
      @event_name = event_name
    end

    attr_reader :user, :event_name

    def mechanisms
      [UserNotificationMechanism.new(user, event_name, "email")]
    end
  end

  class UserNotificationMechanism
    def initialize(user, event_name, mechanism_name)
      @user = user
      @event_name = event_name
      @name = mechanism_name
    end

    attr_reader :name

    def enabled?
      @user.notification_preferences(@event_name).include?(name)
    end
  end

  def notifications_preferences(user)
    ["changeset_comment", "note_comment"].map do |event_name|
      UserNotificationPreference.new(user, event_name)
    end
  end
end
