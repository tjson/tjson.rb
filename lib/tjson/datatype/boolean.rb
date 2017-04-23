# frozen_string_literal: true

module TJSON
  class DataType
    # Boolean Value
    class Boolean < Scalar
      def tag
        "b"
      end

      def decode(value)
        raise TJSON::TypeError, "'null' is expressly disallowed in TJSON" if value.nil?
        raise TJSON::TypeError, "not a boolean value: #{value.inspect}" unless [true, false].include?(value)
        value
      end

      def encode(value)
        value
      end
    end
  end
end
