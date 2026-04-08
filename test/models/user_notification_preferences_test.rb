# frozen_string_literal: true

require "test_helper"

class UserNotificationPreferencesTest < ActiveSupport::TestCase
  def test_all_enabled_by_default
    user = create(:user)
    preferences = UserNotificationPreferences.new(user)
    assert_equal ["email"], preferences["changeset_comment"]
    assert_equal ["email"], preferences["diary_comment"]
    assert_equal ["email"], preferences["direct_message"]
    assert_equal ["email"], preferences["new_follower"]
    assert_equal ["email"], preferences["note_comment"]
  end

  def test_ignore_unknown_events
    user = create(:user)
    preferences = UserNotificationPreferences.new(user)

    assert_equal [], preferences["imaginary_event"]
  end

  def test_update
    user = create(:user)
    preferences = UserNotificationPreferences.new(user)
    preferences.update(
      "changeset_comment_email" => true,
      "diary_comment_email" => false,
      "direct_message_email" => 1,
      "new_follower_email" => 0,
      "note_comment_email" => "0",
    )

    assert_equal ["email"], preferences["changeset_comment"]
    assert_equal [], preferences["diary_comment"]
    assert_equal ["email"], preferences["direct_message"]
    assert_equal [], preferences["new_follower"]
    assert_equal [], preferences["note_comment"]
  end
end
