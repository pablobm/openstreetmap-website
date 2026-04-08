# frozen_string_literal: true

class UserNotificationPreferences
  extend ActiveModel::Naming

  EVENTS = %w[
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

    def attribute_name
      "#{@event_preferences.event_name}_#{name}"
    end
  end

  def initialize(user)
    @user = user
  end

  def [](event_name)
    return [] unless EVENTS.include?(event_name)

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
    EVENTS.map { |name| EventPreferences.new(self, name) }
  end

  def update(new_prefs)
    pref_records =
      EVENTS.map do |event_name|
        DELIVERY_MECHANISMS.map do |mechanism|
          attribute_name = "#{event_name}_#{mechanism}"
          next unless new_prefs.key?(attribute_name)

          record = @user.preferences.find_or_initialize_by(:k => "notification.#{event_name}.#{mechanism}")
          record.v = new_prefs[attribute_name]
          record
        end
      end
      .flatten.compact

    UserPreference.transaction do
      pref_records.each(&:save!)
      true
    end
  end

  def to_key
    nil
  end

  def persisted?
    true
  end

  EVENTS.each do |event_name|
    DELIVERY_MECHANISMS.each do |mechanism|
      define_method "#{event_name}_#{mechanism}" do
        self[event_name].include?(mechanism)
      end
    end
  end
end
