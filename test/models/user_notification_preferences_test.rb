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

    assert_equal [], preferences["imaginary_event"]
  end

  def test_update
    user = create(:user)
    preferences = UserNotificationPreferences.new(user)
    preferences.update
  end
end
