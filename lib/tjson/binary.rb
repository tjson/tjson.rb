# frozen_string_literal: true

module TJSON
  # TJSON Binary Data type
  class Binary < ::String
    def self.from_base16(str)
      raise TypeError, "expected String, got #{str.class}" unless str.is_a?(::String)
      raise TJSON::ParseError, "base16 must be lower case: #{str.inspect}" if str =~ /[A-F]/
      raise TJSON::ParseError, "invalid base16: #{str.inspect}" unless str =~ /\A[a-f0-9]*\z/

      [str].pack("H*")
    end
  end
end
