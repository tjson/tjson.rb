# frozen_string_literal: true

module TJSON
  # TJSON array type
  class Array < ::Array
    def <<(obj)
      super(TJSON::TagParser.parse(obj))
    end
  end
end
