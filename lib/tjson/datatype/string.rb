# frozen_string_literal: true

module TJSON
  class DataType
    # Unicode String type
    class String < Scalar
      def tag
        "s"
      end

      def decode(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::EncodingError, "expected UTF-8, got #{str.encoding.inspect}" unless str.encoding == Encoding::UTF_8
        str
      end

      def encode(obj)
        obj.to_s
      end
    end
  end
end
