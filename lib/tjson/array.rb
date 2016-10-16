# frozen_string_literal: true

module TJSON
  # TJSON array type
  class Array < ::Array
    def <<(obj)
      super(TJSON::UTF8String.parse(obj))
    end
  end
end
