# frozen_string_literal: true

module TJSON
  # Postprocessing for extracting TJSON tags from JSON
  module Parser
    module_function

    TAG_DELIMITER  = ":"
    MAX_TAG_LENGTH = 3 # Sans ':'

    def value(obj)
      case obj
      when String then parse(obj)
      when Integer then obj.to_f
      when TJSON::Object, TJSON::Array, Float then obj
      else raise TypeError, "invalid TJSON value: #{obj.inspect}"
      end
    end

    def parse(str)
      raise TypeError, "expected String, got #{str.class}" unless str.is_a?(::String)
      raise TJSON::EncodingError, "expected UTF-8, got #{str.encoding.inspect}" unless str.encoding == Encoding::UTF_8

      dpos = str.index(TAG_DELIMITER)

      raise TJSON::ParseError, "invalid tag (missing ':' delimiter)" unless dpos
      raise TJSON::ParseError, "overlength tag (maximum #{MAX_TAG_LENGTH})" if dpos > MAX_TAG_LENGTH

      tag = str.slice!(0, dpos + 1)

      case tag
      when "s:" then str
      when "i:" then parse_signed_int(str)
      when "u:" then parse_unsigned_int(str)
      when "t:" then parse_timestamp(str)
      when "b16:" then parse_base16(str)
      when "b32:" then parse_base32(str)
      when "b64:" then parse_base64url(str)
      else raise TJSON::ParseError, "invalid tag #{tag.inspect} on string #{str.inspect}"
      end
    end

    def parse_base16(str)
      raise TypeError, "expected String, got #{str.class}" unless str.is_a?(::String)
      raise TJSON::ParseError, "base16 must be lower case: #{str.inspect}" if str =~ /[A-F]/
      raise TJSON::ParseError, "invalid base16: #{str.inspect}" unless str =~ /\A[a-f0-9]*\z/

      [str].pack("H*")
    end

    def parse_base32(str)
      raise TypeError, "expected String, got #{str.class}" unless str.is_a?(::String)
      raise TJSON::ParseError, "base32 must be lower case: #{str.inspect}" if str =~ /[A-Z]/
      raise TJSON::ParseError, "padding disallowed: #{str.inspect}" if str.include?("=")
      raise TJSON::ParseError, "invalid base32: #{str.inspect}" unless str =~ /\A[a-z2-7]*\z/

      Base32.decode(str.upcase).force_encoding(Encoding::BINARY)
    end

    def parse_base64url(str)
      raise TypeError, "expected String, got #{str.class}" unless str.is_a?(::String)
      raise TJSON::ParseError, "base64url only: #{str.inspect}" if str =~ %r{\+|\/}
      raise TJSON::ParseError, "padding disallowed: #{str.inspect}" if str.include?("=")
      raise TJSON::ParseError, "invalid base64url: #{str.inspect}" unless str =~ /\A[A-Za-z0-9\-_]*\z/

      # Add padding, as older Rubies (< 2.3) require it
      str = str.ljust((str.length + 3) & ~3, "=") if (str.length % 4).nonzero?

      Base64.urlsafe_decode64(str)
    end

    def parse_signed_int(str)
      raise TJSON::ParseError, "invalid integer: #{str.inspect}" unless str =~ /\A\-?(0|[1-9][0-9]*)\z/

      result = Integer(str, 10)
      raise TJSON::ParseError, "oversized integer: #{result}"  if result > 9_223_372_036_854_775_807
      raise TJSON::ParseError, "undersized integer: #{result}" if result < -9_223_372_036_854_775_808

      result
    end

    def parse_unsigned_int(str)
      raise TJSON::ParseError, "invalid integer: #{str.inspect}" unless str =~ /\A(0|[1-9][0-9]*)\z/

      result = Integer(str, 10)
      raise TJSON::ParseError, "oversized integer: #{result}" if result > 18_446_744_073_709_551_615

      result
    end

    def parse_timestamp(str)
      raise TJSON::ParseError, "invalid timestamp: #{str.inspect}" unless str =~ /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\z/

      Time.iso8601(str)
    end
  end
end
