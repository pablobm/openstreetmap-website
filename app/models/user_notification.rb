# frozen_string_literal: true

class UserNotification
  LISTABLE_NOTIFICATIONS = %w[
    ChangesetCommentNotifier::Notification
    DiaryCommentNotifier::Notification
    GpxImportFailureNotifier::Notification
    GpxImportSuccessNotifier::Notification
    NewFollowerNotifier::Notification
    NoteCommentNotifier::Notification
  ].freeze
end
