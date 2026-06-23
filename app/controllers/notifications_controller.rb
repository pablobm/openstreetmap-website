# frozen_string_literal: true

class NotificationsController < ApplicationController
  include PaginationMethods

  LISTABLE_NOTIFICATIONS = %w[
    ChangesetCommentNotifier::Notification
    DiaryCommentNotifier::Notification
    GpxImportFailureNotifier::Notification
    GpxImportSuccessNotifier::Notification
    NewFollowerNotifier::Notification
    NoteCommentNotifier::Notification
  ].freeze

  layout :site_layout

  before_action :authorize_web
  before_action :set_locale

  authorize_resource :class => false

  before_action :check_database_readable

  def index
    # JUST FOR DEBUGGING PURPOSES, TO REMOVE
    if params[:mark_all_unread]
      current_user.notifications.update(:read_at => nil)
      redirect_back_or_to notifications_path
      return
    end

    records =
      current_user
      .notifications
      .where(:type => LISTABLE_NOTIFICATIONS)
      .where(:read_at => nil)

    @notifications = get_page_items(records)
    @params = params.permit
  end
end
