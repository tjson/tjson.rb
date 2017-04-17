# frozen_string_literal: true

module TJSON
  class DataType
    # Boolean Value
    class Value < Scalar
      def tag
        "v"
      end

      def convert(value)
        raise TJSON::TypeError, "'null' is expressly disallowed in TJSON" if value.nil?
        raise TJSON::TypeError, "not a boolean value: #{value.inspect}" unless [true, false].include?(value)
        value
      end

      def generate(value)
        value
      end
    end
  end
end
