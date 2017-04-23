# frozen_string_literal: true

module TJSON
  class DataType
    # Floating point type
    class Float < Scalar
      def tag
        "f"
      end

      def decode(float)
        raise TJSON::TypeError, "not a floating point value: #{float.inspect}" unless float.is_a?(::Numeric)
        float.to_f
      end

      def encode(float)
        float.to_f
      end
    end
  end
end
