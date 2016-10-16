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
      when "b16:" then TJSON::Binary.from_base16(str)
      else raise TJSON::ParseError, "invalid tag #{tag.inspect} on string #{str.inspect}"
      end
    end
  end
end