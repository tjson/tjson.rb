# frozen_string_literal: true

module TJSON
  # TJSON object type (i.e. hash/dict-alike)
  class Object < ::Hash
    def []=(name, value)
      super(TJSON::UTF8String.parse(name), TJSON::UTF8String.parse(value))
    end
  end
end
