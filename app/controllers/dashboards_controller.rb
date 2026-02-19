# frozen_string_literal: true

class DashboardsController < ApplicationController
  layout :site_layout

  before_action :authorize_web
  before_action :set_locale
  before_action :update_totp

  after_action :mark_notifications_as_seen, :only => :show

  authorize_resource :class => false

  before_action :check_database_readable

  def show
    @notifications = current_user.pending_notifications.includes(:event)
    @followings = current_user.followings
    @nearby_users = current_user.nearby - @followings
  end

  private

  def mark_notifications_as_seen
    @notifications.update_all(:seen_at => Time.zone.now)
  end
end
