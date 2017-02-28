# frozen_string_literal: true

module TJSON
  class DataType
    # RFC3339 timestamp (Z-normalized)
    class Timestamp < Scalar
      def tag
        "t"
      end

      def convert(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        unless str =~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z\z/
          raise TJSON::ParseError, "invalid timestamp: #{str.inspect}"
        end

        ::Time.iso8601(str)
      end

      def generate(timestamp)
        timestamp.to_time.utc.iso8601
      end
    end
  end
end
