# frozen_string_literal: true

module TJSON
  # TJSON array type
  class Array < ::Array
    def <<(obj)
      super(TJSON::TagParser.value(obj))
    end
  end
end
