# frozen_string_literal: true

require "test_helper"

class Notifications
  class ChangesetCommentViewTest < ActionView::TestCase
    def test_render
      comment_author = build_stubbed(
        :user,
        :display_name => "Helpful Commenter"
      )
      changeset = build_stubbed(:changeset)
      changeset_comment = build_stubbed(
        :changeset_comment,
        :author => comment_author,
        :changeset => changeset
      )
      notification = Struct.new(:record).new(changeset_comment)
      notification_wrapper = UserNotifications::ChangesetCommentNotification.new(notification)

      render "notifications/changeset_comment", :notification => notification_wrapper

      assert_dom ".user-notification h2", "Changeset comment"
      assert_dom ".user-notification time", "less than 1 minute ago"
      assert_dom ".user-notification blockquote", changeset.comment
    end
  end
end
