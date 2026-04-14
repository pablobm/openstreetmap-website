# frozen_string_literal: true

require "test_helper"

class UserNotificationPreferencesTest < ActiveSupport::TestCase
  def test_all_enabled_by_default
    preferences = UserNotificationPreferences.new(create(:user))
    assert_equal ["email"], preferences.changeset_comment
    assert_equal ["email"], preferences.diary_comment
    assert_equal ["email"], preferences.direct_message
    assert_equal ["email"], preferences.new_follower
    assert_equal ["email"], preferences.note_comment
  end

  def test_update
    preferences = UserNotificationPreferences.new(create(:user))
    preferences.update(
      "changeset_comment" => ["email"],
      "diary_comment" => [],
      "direct_message" => ["email"],
      "new_follower" => []
    )

    assert_equal ["email"], preferences.changeset_comment
    assert_equal [], preferences.diary_comment
    assert_equal ["email"], preferences.direct_message
    assert_equal [], preferences.new_follower

    # Default value
    assert_equal ["email"], preferences.note_comment
  end

  def test_update_ignore_invalid_values
    preferences = UserNotificationPreferences.new(create(:user))

    preferences.update("changeset_comment" => ["whatsapp"])

    assert_equal [], preferences.changeset_comment
    assert_equal 0, UserPreference.where("k LIKE 'notification.changeset_comment.whatsapp'").count

    preferences.update("changeset_comment" => %w[whatsapp email])
    assert_equal ["email"], preferences.changeset_comment
    assert_equal 0, UserPreference.where("k LIKE 'notification.changeset_comment.whatsapp'").count

    preferences.update("imaginary_event" => ["email"])
  end

  def test_update_leave_alone_unmentioned_events
    preferences = UserNotificationPreferences.new(create(:user))
    preferences.update(
      "changeset_comment" => ["email"],
      "diary_comment" => []
    )
    assert_equal 1, UserPreference.where("k LIKE 'notification.changeset_comment.%'").count
    assert_equal 1, UserPreference.where("k LIKE 'notification.diary_comment.%'").count
    assert_equal 0, UserPreference.where("k LIKE 'notification.direct_message.%'").count
    assert_equal 0, UserPreference.where("k LIKE 'notification.new_follower.%'").count
  end
end
