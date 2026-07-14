# frozen_string_literal: true

require "test_helper"
require_relative "view_test"

module Notifications
  class NoteCommentViewTest < ViewTest
    def test_render
      comment_author = build_stubbed(
        :user,
        :display_name => "Helpful Commenter"
      )
      note = build_stubbed(:note)
      note_comment = build_stubbed(
        :note_comment,
        :author => comment_author,
        :note => note
      )
      notification = build_stubbed(:notification, :record => note_comment)

      render(
        "notifications/notification",
        :notification => notification
      )

      assert_dom ".web-notification" do
        assert_dom "h2", "Note comment"
        assert_dom "time", "less than 1 minute ago"
        assert_dom "blockquote", note_comment.body
      end
    end

    def test_render_with_long_text
      comment_author = build_stubbed(
        :user,
        :display_name => "Helpful Commenter"
      )
      note = build_stubbed(:note)
      note_comment = build_stubbed(
        :note_comment,
        :author => comment_author,
        :note => note,
        :body => read_fixture_file("lorem_ipsum.txt")
      )
      notification = build_stubbed(:notification, :record => note_comment)

      render(
        "notifications/notification",
        :notification => notification
      )

      assert_dom ".web-notification blockquote p", :count => 3
    end
  end
end
