# frozen_string_literal: true

module TJSON
  # TJSON array type
  class Array < ::Object
    def initialize
      @members = ::Array.new
    end

    def <<(obj)
      @members << TJSON::UTF8String.parse(obj)
    end
  end
end
