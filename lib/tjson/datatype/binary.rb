# frozen_string_literal: true

module TJSON
  class DataType
    # Base16-serialized binary data
    class Binary16 < Scalar
      def tag
        "d16"
      end

      def decode(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "base16 must be lower case: #{str.inspect}" if str =~ /[A-F]/
        raise TJSON::ParseError, "invalid base16: #{str.inspect}" unless str =~ /\A[a-f0-9]*\z/

        [str].pack("H*")
      end

      def encode(binary)
        binary.unpack("H*").first
      end
    end

    # Base32-serialized binary data
    class Binary32 < Scalar
      def tag
        "d32"
      end

      def decode(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "base32 must be lower case: #{str.inspect}" if str =~ /[A-Z]/
        raise TJSON::ParseError, "padding disallowed: #{str.inspect}" if str.include?("=")
        raise TJSON::ParseError, "invalid base32: #{str.inspect}" unless str =~ /\A[a-z2-7]*\z/

        ::Base32.decode(str.upcase).force_encoding(Encoding::BINARY)
      end

      def encode(binary)
        Base32.encode(binary).downcase.delete("=")
      end
    end

    # Base64-serialized binary data
    class Binary64 < Scalar
      def tag
        "d64"
      end

      def decode(str)
        raise TJSON::TypeError, "expected String, got #{str.class}: #{str.inspect}" unless str.is_a?(::String)
        raise TJSON::ParseError, "base64url only: #{str.inspect}" if str =~ %r{\+|\/}
        raise TJSON::ParseError, "padding disallowed: #{str.inspect}" if str.include?("=")
        raise TJSON::ParseError, "invalid base64url: #{str.inspect}" unless str =~ /\A[A-Za-z0-9\-_]*\z/

        # Add padding, as older Rubies (< 2.3) require it
        str = str.ljust((str.length + 3) & ~3, "=") if (str.length % 4).nonzero?

        ::Base64.urlsafe_decode64(str)
      end

      def encode(binary)
        Base64.urlsafe_encode64(binary).delete("=")
      end
    end
  end
end
