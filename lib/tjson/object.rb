# frozen_string_literal: true

module TJSON
  # TJSON object type (i.e. hash/dict-alike)
  class Object < ::Hash
    def []=(name, value)
      unless name.start_with?("u:", "b16:", "b64:")
        if name.include?(":")
          raise TJSON::ParseError, "invalid tag on object name: #{name[/\A(.*?):/, 1]}"
        else
          raise TJSON::ParseError, "no tag found on object name: #{name.inspect}"
        end
      end

      super(TJSON::TagParser.parse(name), TJSON::TagParser.parse(value))
    end
  end
end
