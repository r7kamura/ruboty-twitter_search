module Ruboty
  module TwitterSearch
    class StatusesView
      def initialize(statuses)
        @statuses = statuses
      end

      def to_s
        source_urls.reverse.join("\n")
      end

      private

      def source_urls
        @statuses.map do |status|
          "https://twitter.com/#{status.user.screen_name}/status/#{status.id}"
        end
      end
    end
  end
end
