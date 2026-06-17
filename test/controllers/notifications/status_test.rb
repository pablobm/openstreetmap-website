# frozen_string_literal: true

require "test_helper"

module Notifications
  class StatusesTest < ActionDispatch::IntegrationTest
    def test_update
      user1 = create(:user)
      user2 = create(:user)
      n1 = create(:changeset_comment_notification, :recipient => user1)
      n2 = create(:changeset_comment_notification, :recipient => user2)

      session_for(user1)

      assert_difference -> { Noticed::Notification.unread.count } => -1 do
        patch notifications_status_path, :params => { :notifications => { n1.id => "read", n2.id => "read" } }
      end
      assert_redirected_to notifications_path
    end
  end
end
