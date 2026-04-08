# frozen_string_literal: true

require "test_helper"

class NewFollowerNotifierTest < ActiveSupport::TestCase
  def setup
    ActionMailer::Base.deliveries.clear
  end

  def test_send_email_when_subscribed
    user = create(:user)
    user.notification_preferences.update("new_follower_email" => 1)
    follow = create(:follow, :following => user)

    deliver_notification(follow)
    email = ActionMailer::Base.deliveries.first
    assert_equal [user.email], email.to
  end

  def test_do_not_send_email_when_not_subscribed
    user = create(:user)
    user.notification_preferences.update("new_follower_email" => 0)
    follow = create(:follow, :following => user)

    deliver_notification(follow)
    assert_empty ActionMailer::Base.deliveries
  end

  private

  def deliver_notification(record)
    perform_enqueued_jobs do
      NewFollowerNotifier.with(:record => record).deliver
    end
  end
end
