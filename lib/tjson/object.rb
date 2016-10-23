# frozen_string_literal: true

module TJSON
  # TJSON object type (i.e. hash/dict-alike)
  class Object < ::Hash
    def []=(name, value)
      unless name.start_with?("s:", "b16:", "b64:")
        raise TJSON::ParseError, "invalid tag on object name: #{name[/\A(.*?):/, 1]}" if name.include?(":")
        raise TJSON::ParseError, "no tag found on object name: #{name.inspect}"
      end

      name = TJSON::TagParser.value(name)
      raise TJSON::DuplicateNameError, "duplicate member name: #{name.inspect}" if key?(name)

      super(name, TJSON::TagParser.value(value))
    end
  end
end
