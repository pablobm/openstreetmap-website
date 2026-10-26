# frozen_string_literal: true

require "test_helper"

class ImportingTraces < ActionDispatch::IntegrationTest
  test "Deleting a trace during import does not notify of a failure" do
    $thread = nil
    trace = create(:trace, :fixture => "a")
    def trace.import
      $thread = Thread.new(self) { |trc| TraceDestroyerJob.perform_now(trc) }
      Thread.pass
      super
    end

    assert_difference "GpxImportFailureNotifier::Notification.count", 0 do
      TraceImporterJob.perform_now(trace)
    end
    $thread.join
  end
end
