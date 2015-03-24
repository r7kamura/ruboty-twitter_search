require "ruboty"
require "twitter"
require "yaml"

module Ruboty
  module Handlers
    class TwitterSearch < Base
      NAMESPACE = "twitter-search"

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
        message = Message.parse(message[:query])
        # http://www.rubydoc.info/gems/twitter/Twitter/REST/Search#search-instance_method
        statuses = client.search(message.word, since_id: fetch_since_id_for(message.since_id)).take(10)
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

    class Message
      DELIMITER = ' '

      def self.parse(query)
        return self.new({'word' => query}) if query.split(DELIMITER).size == 1
        options = JSON.parse("{#{query.gsub(/(\w+):(\w+)/, '"\1":"\2",').chomp(',')}}") # go bold
        self.new(options)
      end

      def initialize(options)
        @options = options
      end

      def word
        @options['word']
      end

      def since_id
        @options['since_id']
      end

      def retweet
        @options['retweet']
      end

      def fav
        @options['fav']
      end
    end
  end
end
