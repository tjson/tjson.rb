# frozen_string_literal: true

module TJSON
  class DataType
    # RFC3339 timestamp (Z-normalized)
    class Timestamp < Scalar
      # Regular expression for matching timestamps
      TIMESTAMP_REGEX = /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/

      def tag
        "t"
      end

      def convert(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "invalid timestamp: #{str.inspect}" unless str.match?(TIMESTAMP_REGEX)

        ::Time.iso8601(str)
      end

      def generate(timestamp)
        timestamp.to_time.utc.iso8601
      end
    end
  end
end
