# frozen_string_literal: true

require "test_helper"
require_relative "view_test"

module Notifications
  class NewFollowerViewTest < ViewTest
    def test_render
      following = build_stubbed(:user)
      follower = build_stubbed(:user, :display_name => "Follower")
      follow = build_stubbed(:follow, :follower => follower, :following => following)

      notification = build_stubbed(
        :notification,
        :record => follow,
        :notifier_class => NewFollowerNotifier
      )

      render(
        "notifications/notification",
        :notification => notification
      )

      assert_dom ".web-notification" do
        assert_dom "h2", "New follower"
        assert_dom "time", "less than 1 minute ago"
        assert_dom "p", "User Follower started following you. You can follow them back if you wish."
      end
    end
  end
end
