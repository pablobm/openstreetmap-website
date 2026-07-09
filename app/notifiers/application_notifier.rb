# frozen_string_literal: true

class ApplicationNotifier < Noticed::Event
  class Notification < Noticed::Notification
    def render_in(view_context)
      # Turn "ChangesetCommentNotifier::Notification" into "ChangesetComment"
      event_type_name = self.class.name.sub("Notifier::Notification", "")

      view_context.render(
        "notifications/#{event_type_name.underscore}",
        :notification => self,
        :record => record
      )
    end
  end
end
