# frozen_string_literal: true

module TJSON
  # TJSON object type (i.e. hash/dict-alike)
  class Object < ::Object
    def initialize
      @members = ::Hash.new
    end

    def []=(name, value)
      @members[TJSON::UTF8String.parse(name)] = TJSON::UTF8String.parse(value)
    end
  end
end
