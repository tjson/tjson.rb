# frozen_string_literal: true

module TJSON
  class DataType
    # Base class of integer types
    class Integer < Scalar
      def generate(int)
        # Integers are serialized as strings to sidestep the limits of some JSON parsers
        int.to_s
      end
    end

    # Signed 64-bit integer
    class SignedInt < Integer
      def tag
        "i"
      end

      def convert(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "invalid integer: #{str.inspect}" unless str.match?(/\A\-?(0|[1-9][0-9]*)\z/)

        result = Integer(str, 10)
        raise TJSON::ParseError, "oversized integer: #{result}"  if result > 9_223_372_036_854_775_807
        raise TJSON::ParseError, "undersized integer: #{result}" if result < -9_223_372_036_854_775_808

        result
      end
    end

    # Unsigned 64-bit integer
    class UnsignedInt < Integer
      def tag
        "u"
      end

      def convert(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "invalid integer: #{str.inspect}" unless str.match?(/\A(0|[1-9][0-9]*)\z/)

        result = Integer(str, 10)
        raise TJSON::ParseError, "oversized integer: #{result}" if result > 18_446_744_073_709_551_615

        result
      end
    end
  end
end
