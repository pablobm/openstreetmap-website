# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authorize_web

  authorize_resource :class => Noticed::Notification

  def clear_all
    num_cleared = current_user.notifications.update_all(:read_at => Time.zone.now)
    redirect_back_or_to :dashboard, :notice => "Cleared #{num_cleared} notifications"
  end
end
