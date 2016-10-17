# frozen_string_literal: true

module TJSON
  # Parses tagged strings from TJSON
  module TagParser
    module_function

    TAG_DELIMITER  = ":"
    MAX_TAG_LENGTH = 3 # Sans ':'

    def parse(str)
      raise TypeError, "expected String, got #{str.class}" unless str.is_a?(::String)
      raise TJSON::EncodingError, "expected UTF-8, got #{str.encoding.inspect}" unless str.encoding == Encoding::UTF_8

      dpos = str.index(TAG_DELIMITER)

      raise TJSON::ParseError, "invalid tag (missing ':' delimiter)" unless dpos
      raise TJSON::ParseError, "overlength tag (maximum #{MAX_TAG_LENGTH})" if dpos > MAX_TAG_LENGTH

      tag = str.slice!(0, dpos + 1)

      case tag
      when "u:" then str
      when "i:" then from_integer(str)
      when "b16:" then from_base16(str)
      when "b64:" then from_base64url(str)
      else raise TJSON::ParseError, "invalid tag #{tag.inspect} on string #{str.inspect}"
      end
    end

    def from_base16(str)
      raise TypeError, "expected String, got #{str.class}" unless str.is_a?(::String)
      raise TJSON::ParseError, "base16 must be lower case: #{str.inspect}" if str =~ /[A-F]/
      raise TJSON::ParseError, "invalid base16: #{str.inspect}" unless str =~ /\A[a-f0-9]*\z/

      [str].pack("H*")
    end

    def from_base64url(str)
      raise TypeError, "expected String, got #{str.class}" unless str.is_a?(::String)
      raise TJSON::ParseError, "base64url only: #{str.inspect}" if str =~ %r{\+|\/}
      raise TJSON::ParseError, "padding disallowed: #{str.inspect}" if str.include?("=")
      raise TJSON::ParseError, "invalid base64url: #{str.inspect}" unless str =~ /\A[A-Za-z0-9\-_]*\z/

      Base64.urlsafe_decode64(str)
    end

    def from_integer(str)
      raise TJSON::ParseError, "invalid integer: #{str.inspect}" unless str =~ /\A\-?(0|[1-9][0-9]*)\z/

      result = Integer(str, 10)
      raise TJSON::ParseError, "oversized integer: #{result}"  if result > 9_223_372_036_854_775_807
      raise TJSON::ParseError, "undersized integer: #{result}" if result < -9_223_372_036_854_775_808

      result
    end
  end
end
