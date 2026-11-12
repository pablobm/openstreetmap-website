# frozen_string_literal: true

require "test_helper"

module Notifications
  class ReadsControllerTest < ActionDispatch::IntegrationTest
    def test_routes
      assert_routing(
        { :path => "/notifications/unreads", :method => :post },
        { :controller => "notifications/unreads", :action => "create" }
      )

      assert_routing(
        { :path => "/notifications/123/unreads", :method => :post },
        { :controller => "notifications/unreads", :action => "create", :notification_id => "123" }
      )
    end

    def test_create_unauthorized
      user1 = create(:user)
      user2 = create(:user)
      n1 = create(:changeset_comment_notification, :recipient => user1)
      n2 = create(:changeset_comment_notification, :recipient => user2)

      assert_difference(unread_counter, 0) do
        post notifications_reads_path, :params => { :notification_ids => [n1.id, n2.id] }
      end
      assert_response :forbidden
    end

    def test_create_single_mine_unread
      user1 = create(:user)
      user2 = create(:user)
      n1a = create(:changeset_comment_notification, :recipient => user1)
      n1b = create(:changeset_comment_notification, :recipient => user1, :read_at => 1.minute.ago)
      n1c = create(:changeset_comment_notification, :recipient => user1)
      n2 = create(:changeset_comment_notification, :recipient => user2)

      session_for(user1)

      assert_difference(unread_counter, 0) do
        post notification_unreads_path(n1a)
      end
      assert_redirected_to notifications_path
    end

    def test_create_single_mine_read
      user1 = create(:user)
      user2 = create(:user)
      n1a = create(:changeset_comment_notification, :recipient => user1)
      n1b = create(:changeset_comment_notification, :recipient => user1, :read_at => 1.minute.ago)
      n1c = create(:changeset_comment_notification, :recipient => user1)
      n2 = create(:changeset_comment_notification, :recipient => user2)

      session_for(user1)

      assert_difference(unread_counter, 1) do
        post notification_unreads_path(n1b)
      end
      assert_redirected_to notifications_path
    end


    def test_create_bulk
      user1 = create(:user)
      user2 = create(:user)
      n1a = create(:changeset_comment_notification, :recipient => user1)
      n1b = create(:changeset_comment_notification, :recipient => user1, :read_at => 1.minute.ago)
      n1c = create(:changeset_comment_notification, :recipient => user1)
      n2 = create(:changeset_comment_notification, :recipient => user2)

      session_for(user1)

      assert_difference(unread_counter, 1) do
        post notifications_unreads_path, :params => { :notification_ids => [n1b.id, n1c.id, n2.id] }
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
