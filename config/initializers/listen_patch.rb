# frozen_string_literal: true
module ActiveSupport
  class EventedFileUpdateChecker
    private

    def boot!
      Listen.to(*@dtw, force_polling: true, &method(:changed)).start
    end
  end
end if Rails.env.development? && ENV["LISTEN_USE_POLLING"] == "yes"
