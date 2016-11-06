# frozen_string_literal: true

module TJSON
  class DataType
    # RFC3339 timestamp (Z-normalized)
    class Timestamp < Scalar
      def convert(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "invalid timestamp: #{str.inspect}" unless str =~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/

        ::Time.iso8601(str)
      end
    end
  end
end
