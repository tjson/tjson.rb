# frozen_string_literal: true

module TJSON
  class DataType
    # Numbers
    class Number < Scalar; end
    class Integer < Scalar; end

    # Floating point type
    class Float < Number
      def convert(float)
        raise TJSON::TypeError, "expected Float, got #{float.class}" unless float.is_a?(::Numeric)
        float.to_f
      end
    end

    # Signed 64-bit integer
    class SignedInt < Integer
      def convert(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "invalid integer: #{str.inspect}" unless str =~ /\A\-?(0|[1-9][0-9]*)\z/

        result = Integer(str, 10)
        raise TJSON::ParseError, "oversized integer: #{result}"  if result > 9_223_372_036_854_775_807
        raise TJSON::ParseError, "undersized integer: #{result}" if result < -9_223_372_036_854_775_808

        result
      end
    end

    # Unsigned 64-bit integer
    class UnsignedInt < Integer
      def convert(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "invalid integer: #{str.inspect}" unless str =~ /\A(0|[1-9][0-9]*)\z/

        result = Integer(str, 10)
        raise TJSON::ParseError, "oversized integer: #{result}" if result > 18_446_744_073_709_551_615

        result
      end
    end
  end
end
