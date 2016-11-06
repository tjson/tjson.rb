# frozen_string_literal: true

module TJSON
  class DataType
    # TJSON arrays
    class Array < NonScalar
      # Determine the type of a Ruby array (for serialization)
      def self.identify_type(array)
        inner_type = nil

        array.each do |elem|
          t = TJSON::DataType.identify_type(elem)
          inner_type ||= t
          raise TJSON::TypeError, "array contains heterogenous types: #{array.inspect}" unless inner_type == t
        end

        new(inner_type)
      end

      def tag
        "A<#{@inner_type.tag}>"
      end

      def convert(array)
        raise TJSON::TypeError, "expected Array, got #{array.class}" unless array.is_a?(::Array)

        return array.map! { |o| @inner_type.convert(o) } if @inner_type
        return array if array.empty?
        raise TJSON::ParseError, "no inner type specified for non-empty array: #{array.inspect}"
      end

      def generate(array)
        array.map { |o| TJSON::DataType.generate(o) }
      end
    end
  end
end
