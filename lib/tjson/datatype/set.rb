# frozen_string_literal: true

module TJSON
  class DataType
    # TJSON sets
    class Set < NonScalar
      # Determine the type of a Ruby array (for serialization)
      def self.identify_type(array)
        inner_type = nil

        array.each do |elem|
          t = TJSON::DataType.identify_type(elem)
          inner_type ||= t
          raise TJSON::TypeError, "set contains heterogenous types: #{array.inspect}" unless inner_type == t
        end

        new(inner_type)
      end

      def tag
        "S<#{@inner_type.tag}>"
      end

      def convert(array)
        raise TJSON::TypeError, "expected Array, got #{array.class}" unless array.is_a?(::Array)

        if @inner_type
          result = ::Set.new(array.map { |o| @inner_type.convert(o) })
          raise TJSON::ParseError, "set contains duplicate items" if result.size < array.size
          return result
        end

        return ::Set.new if array.empty?
        raise TJSON::ParseError, "no inner type specified for non-empty set: #{array.inspect}"
      end

      def generate(set)
        set.map { |o| TJSON::DataType.generate(o) }
      end
    end
  end
end
