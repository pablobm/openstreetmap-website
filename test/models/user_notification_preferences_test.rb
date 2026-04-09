# frozen_string_literal: true

require "test_helper"

class UserNotificationPreferencesTest < ActiveSupport::TestCase
  def test_all_enabled_by_default
    user = create(:user)
    preferences = UserNotificationPreferences.new(user)
    assert_equal ["email"], preferences.changeset_comment
    assert_equal ["email"], preferences.diary_comment
    assert_equal ["email"], preferences.direct_message
    assert_equal ["email"], preferences.new_follower
    assert_equal ["email"], preferences.note_comment
  end

  def test_update
    user = create(:user)
    preferences = UserNotificationPreferences.new(user)
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
    assert_equal [], preferences.note_comment
  end

  def test_update_ignore_invalid_values
    user = create(:user)
    preferences = UserNotificationPreferences.new(user)

    preferences.update("changset_comment" => ["whatsapp"])

    assert_equal [], preferences.changeset_comment
    preferences.update("changeset_comment" => %w[whatsapp email])
    assert_equal ["email"], preferences.changeset_comment

    preferences.update("imaginary_event" => ["email"])
  end
end
