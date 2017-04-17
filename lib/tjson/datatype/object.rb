# frozen_string_literal: true

module TJSON
  class DataType
    # TJSON objects
    class Object < NonScalar
      def tag
        "O"
      end

      def convert(obj)
        raise TJSON::TypeError, "expected TJSON::Object, got #{obj.class}" unless obj.is_a?(TJSON::Object)

        # Objects handle their own member conversions
        obj
      end

      def generate(obj)
        members = obj.map do |k, v|
          raise TypeError, "expected String for key, got #{k.class}" unless k.is_a?(::String) || k.is_a?(Symbol)
          type = TJSON::DataType.identify_type(v)
          ["#{k}:#{type.tag}", TJSON::DataType.generate(v)]
        end

        Hash[members]
      end

      def inspect
        "#<#{self.class}>"
      end
    end
  end
end
