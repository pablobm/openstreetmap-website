# frozen_string_literal: true

require "test_helper"

module Notifications
  class ViewTest < ActionView::TestCase
    def setup
      lookup_context.append_view_paths(["app/views/notifications"])
    end
  end
end
