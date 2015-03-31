module Ruboty
  module TwitterSearch
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
