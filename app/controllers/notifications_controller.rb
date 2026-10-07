# frozen_string_literal: true

class NotificationsController < ApplicationController
  include PaginationMethods

  layout :site_layout

  before_action :authorize_web
  before_action :set_locale

  authorize_resource :class => false

  before_action :check_database_readable

  def index
    notifications = current_user.web_notifications
    @notifications = get_page_items(notifications)
    @params = params.permit
  end

  def debug_unread
    current_user
      .web_notifications
      .update(:read_at => nil)

    redirect_back_or_to notifications_path
  end
end
