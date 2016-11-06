# frozen_string_literal: true

module TJSON
  class DataType
    # Non-scalar types
    class NonScalar < TJSON::DataType
      attr_reader :inner_type

      def initialize(inner_type)
        @inner_type = inner_type
      end

      def inspect
        "#<#{self.class}<#{@inner_type.inspect}>>"
      end

      def scalar?
        false
      end
    end

    # TJSON arrays
    class Array < NonScalar
      def convert(array)
        raise TJSON::TypeError, "expected Array, got #{array.class}" unless array.is_a?(::Array)

        return array.map! { |o| @inner_type.convert(o) } if @inner_type
        return array if array.empty?
        raise TJSON::ParseError, "no inner type specified for non-empty array: #{array.inspect}"
      end
    end

    # TJSON objects
    class Object < NonScalar
      def convert(obj)
        raise TJSON::TypeError, "expected TJSON::Object, got #{obj.class}" unless obj.is_a?(TJSON::Object)

        # Objects handle their own member conversions
        obj
      end

      def inspect
        "#<#{self.class}>"
      end
    end
  end
end
