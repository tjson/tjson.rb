# frozen_string_literal: true

module TJSON
  class DataType
    # Scalar types
    class Scalar < TJSON::DataType
      def scalar?
        true
      end

      def inspect
        "#<#{self.class}>"
      end
    end
  end
end
