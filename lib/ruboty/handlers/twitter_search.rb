require "ruboty"
require "twitter"

module Ruboty
  module Handlers
    class TwitterSearch < Base
      NAMESPACE = "twitter-search"
      TWEETS_COUNT = 10

      env :TWITTER_ACCESS_TOKEN, "Twitter access token"
      env :TWITTER_ACCESS_TOKEN_SECRET, "Twitter access token secret"
      env :TWITTER_CONSUMER_KEY, "Twitter consumer key (a.k.a. API key)"
      env :TWITTER_CONSUMER_SECRET, "Twitter consumer secret (a.k.a. API secret)"
      env :TWITTER_DISABLE_SINCE_ID, "Pass 1 to disable using since_id parameter", optional: true

      on(
        /search twitter by (?<query>.+)/,
        description: "Search twitter by given query",
        name: :search,
      )

      # @return [true] to prevent running missing handlers.
      def search(message)
        query = Query.new(message[:query])

        statuses = client.search(
          query.query_string,
          result_type: query.result_type,
          since_id: fetch_since_id_for(message[:query]),
        ).take(TWEETS_COUNT)

        statuses.select! do |status|
          status.retweet_count >= query.minimum_retweet_count
        end

        statuses.select! do |status|
          status.favorite_count >= query.minimum_favorite_count
        end

        if statuses.any?
          message.reply(StatusesView.new(statuses).to_s)
          store_since_id(query: message[:query], since_id: statuses.first.id)
        end
      rescue Twitter::Error => exception
        message.reply("#{exception.class}: #{exception}")
      ensure
        return true
      end

      private

      def client
        @client ||= ::Twitter::REST::Client.new do |config|
          config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
          config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
          config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
          config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
        end
      end

      def disabled_to_use_since_id?
        ENV["TWITTER_DISABLE_SINCE_ID"] == "1"
      end

      # @param query [String] Query string to be passed to Twitter API
      # @return [Integer, nil] since_id or nil
      def fetch_since_id_for(query)
        unless disabled_to_use_since_id?
          store[query]
        end
      end

      # @note To remember since_id for each query.
      def store
        robot.brain.data[NAMESPACE] ||= {}
      end

      def store_since_id(query: nil, since_id: nil)
        unless disabled_to_use_since_id?
          store[query] = since_id
        end
      end

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

      class Token
        def initialize(token_string)
          @token_string = token_string
        end

        # @return [Fixnum, nil]
        def favorite_count
          if @token_string.match(/\Afav:(?<count>\d+)\z/)
            Regexp.last_match(:count).to_i
          end
        end

        def favorite_count_filter?
          !favorite_count.nil?
        end

        def filter?
          favorite_count_filter? || result_type_filter? || retweet_count_filter?
        end

        # @return [String, nil]
        def result_type
          if @token_string.match(/\Aresult_type:(?<type>\w+)\z/)
            Regexp.last_match(:type)
          end
        end

        def result_type_filter?
          !result_type.nil?
        end

        # @return [Fixnum, nil]
        def retweet_count
          if @token_string.match(/\Aretweet:(?<count>\d+)\z/)
            Regexp.last_match(:count).to_i
          end
        end

        def retweet_count_filter?
          !retweet_count.nil?
        end

        def to_s
          @token_string
        end
      end
    end
  end
end
