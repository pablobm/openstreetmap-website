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

  MECHANISMS = %w[
    email
  ].freeze

  def initialize(user)
    @user = user
  end

  # Receives a hash in the form `event => [mechanisms...]`. Eg:
  # `{:changeset_comment => ["email"], :new_follower => []}`
  def update(new_prefs)
    updated_records =
      EVENTS.map do |event_name|
        MECHANISMS.filter_map do |mechanism|
          next unless new_prefs.key?(event_name)

          record = @user.preferences.find_or_initialize_by(:k => "notification.#{event_name}.#{mechanism}")
          record.v = Array.wrap(new_prefs[event_name]).include?(mechanism)
          record
        end
      end.flatten
    UserPreference.transaction do
      updated_records.each(&:save!)
      true
    end
  end

  # Required by ActionView in order to accept this in form_for.
  # Normally it would provide an id to tell which record is
  # targeted by the form. However our form targets
  # the preferences of `current_user` specifically, not just
  # any arbitrary record, so we can put any value here asit
  # will be ignored.
  def to_key
    nil
  end

  # One getter method for each delivery mechanism. Another
  # requirement from ActionView, but at least one with
  # more general utility.
  EVENTS.each do |event_name|
    define_method event_name do
      prefs =
        @user
        .preferences
        .where("k LIKE 'notification.#{event_name}.%'")
        .pluck(:k, :v)
        .to_h
        .transform_keys { |k| k.split(".").last }

      MECHANISMS.filter do |mechanism|
        prefs.key?(mechanism) ? ActiveModel::Type::Boolean.new.cast(prefs[mechanism]) : true
      end
    end
  end
end
