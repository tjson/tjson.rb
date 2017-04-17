# frozen_string_literal: true

module TJSON
  class DataType
    # Floating point type
    class Float < Number
      def tag
        "f"
      end

      def convert(float)
        raise TJSON::TypeError, "not a floating point value: #{float.inspect}" unless float.is_a?(::Numeric)
        float.to_f
      end

      def generate(float)
        float.to_f
      end
    end
  end
end
