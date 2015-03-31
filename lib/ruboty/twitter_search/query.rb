require "ruboty/twitter_search/token"

module Ruboty
  module TwitterSearch
    class Query
      DEFAULT_MINIMUM_FAVORITE_COUNT = 0
      DEFAULT_MINIMUM_RETWEET_COUNT = 0

      # @param [String] original_query_string
      def initialize(original_query_string)
        @original_query_string = original_query_string
      end

      # @return [Fixnum]
      def minimum_favorite_count
        if token = tokens.find(&:favorite_count_filter?)
          token.favorite_count
        else
          DEFAULT_MINIMUM_FAVORITE_COUNT
        end
      end

      # @return [Fixnum]
      def minimum_retweet_count
        if token = tokens.find(&:retweet_count_filter?)
          token.retweet_count
        else
          DEFAULT_MINIMUM_RETWEET_COUNT
        end
      end

      # @return [String]
      def query_string
        tokens.reject(&:filter?).join(" ")
      end

      # @return [String, nil]
      def result_type
        if token = tokens.find(&:result_type_filter?)
          token.result_type
        end
      end

      private

      # @return [Array<Ruboty::Handlers::TwitterSearch::Token>]
      def tokens
        @tokens ||= @original_query_string.split.map do |token_string|
          Token.new(token_string)
        end
      end
    end
  end
end
