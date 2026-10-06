# frozen_string_literal: true

require "test_helper"

module Notifications
  class ReadsControllerTest < ActionDispatch::IntegrationTest
    def test_routes
      assert_routing(
        { :path => "/notifications/reads", :method => :post },
        { :controller => "notifications/reads", :action => "create" }
      )
    end

    def test_create_unauthorized
      user1 = create(:user)
      user2 = create(:user)
      n1 = create(:changeset_comment_notification, :recipient => user1)
      n2 = create(:changeset_comment_notification, :recipient => user2)

      assert_difference(unread_counter, 0) do
        post notifications_reads_path, :params => { :add => "Mark as read", :notification_ids => [n1.id, n2.id] }
      end
      assert_response :forbidden
    end

    def test_create_add
      user1 = create(:user)
      user2 = create(:user)
      n1a = create(:changeset_comment_notification, :recipient => user1)
      n1b = create(:changeset_comment_notification, :recipient => user1, :read_at => 1.minute.ago)
      n1c = create(:changeset_comment_notification, :recipient => user1)
      n2 = create(:changeset_comment_notification, :recipient => user2)

      session_for(user1)

      assert_difference(unread_counter, -1) do
        post notifications_reads_path, :params => { :add => "Mark as read", :notification_ids => [n1a.id, n1b.id, n2.id] }
      end
      assert_redirected_to notifications_path
    end

    def test_create_remove
      user1 = create(:user)
      user2 = create(:user)
      n1a = create(:changeset_comment_notification, :recipient => user1)
      n1b = create(:changeset_comment_notification, :recipient => user1, :read_at => 1.minute.ago)
      n1c = create(:changeset_comment_notification, :recipient => user1)
      n2 = create(:changeset_comment_notification, :recipient => user2)

      session_for(user1)

      assert_difference(unread_counter, 1) do
        post notifications_reads_path, :params => { :remove => "Mark as unread", :notification_ids => [n1b.id, n1c.id, n2.id] }
      end
      assert_redirected_to notifications_path
    end

    def test_create_missing_params
      user1 = create(:user)
      user2 = create(:user)
      create(:changeset_comment_notification, :recipient => user1)
      create(:changeset_comment_notification, :recipient => user2)

      session_for(user1)

      assert_difference(unread_counter, 0) do
        post notifications_reads_path
      end
      assert_redirected_to notifications_path
    end

    private

    def unread_counter
      -> { Noticed::Notification.unread.count }
    end
  end
end
