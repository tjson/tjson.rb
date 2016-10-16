# frozen_string_literal: true

module TJSON
  # TJSON object type (i.e. hash/dict-alike)
  class Object < ::Hash
    def []=(name, value)
      super(TJSON::TagParser.parse(name), TJSON::TagParser.parse(value))
    end
  end
end
