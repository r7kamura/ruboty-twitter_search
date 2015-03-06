require "ruboty"

module Ruboty
  module Handlers
    class TwitterSearch < Base
      on(
        /search twitter by (?<query>.+)/,
        description: "Search twitter by given query",
        name: :search,
      )

      # @todo
      def search(message)
        Ruboty.logger.debug("#{self.class}##{__method__} was called")
      end
    end
  end
end
