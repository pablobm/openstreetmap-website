# frozen_string_literal: true

require "test_helper"

class NotificationPreferencesTest < ActionDispatch::IntegrationTest
  def test_toggling_preferences
    user = create(:user)
    post "/login", :params => { :username => user.email, :password => "s3cr3t" }
    follow_redirect!

    get notifications_preferences_path

    assert_select "inputs.notification_preference", 7 do
      assert_select "[checked]", true
    end

    assert_select "inputs#direct_message_email", 1 do
      assert_select "[checked]", true
    end

    follow1 = create(:follow, :following => user)
    perform_enqueued_jobs do
      NewFollowerNotifier.with(:record => follow1).deliver
    end
    email = ActionMailer::Base.deliveries.first
    assert_equal 1, email.to.count
    assert_equal user.email, email.to.first

    put notifications_preferences_path, :params => { :direct_message => { :email => "0" } }

    follow2 = create(:follow, :following => user)
    perform_enqueued_jobs do
      NewFollowerNotifier.with(:record => follow2).deliver
    end
    assert_empty ActionMailer::Base.deliveries.first
  end
end
