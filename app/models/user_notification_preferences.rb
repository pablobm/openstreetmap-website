# frozen_string_literal: true

class UserNotificationPreferences
  extend ActiveModel::Naming

  EVENT_NAMES = %w[
    changeset_comment
    diary_comment
    direct_message
    new_follower
    note_comment
  ].freeze

  DELIVERY_MECHANISMS = %w[
    email
  ].freeze

  class EventPreferences
    def initialize(preferences, event_name)
      @preferences = preferences
      @event_name = event_name
    end

    attr_reader :event_name, :preferences

    def mechanisms
      DELIVERY_MECHANISMS.map { |mechanism| MechanismChoices.new(self, mechanism) }
    end
  end

  class MechanismChoices
    def initialize(event_preferences, name)
      @event_preferences = event_preferences
      @name = name
    end

    attr_reader :name

    def enabled?
      @event_preferences.preferences[name]
    end
  end

  def initialize(user)
    @user = user
  end

  def [](event_name)
    return [] unless EVENT_NAMES.include?(event_name)

    prefs =
      @user
      .preferences
      .where("k LIKE 'notification.#{event_name}.%'")
      .pluck(:k, :v)
      .to_h
      .transform_keys { |k| k.split(".").last }

    DELIVERY_MECHANISMS.filter do |mechanism|
      prefs.key?(mechanism) ? ActiveModel::Type::Boolean.new.cast(prefs[mechanism]) : true
    end
  end

  def event_preferences
    EVENT_NAMES.map { |name| EventPreferences.new(self, name) }
  end

  def update(new_prefs)
  end

  def to_key
    ["current_user"]
  end

  def persisted?
    true
  end
end
